
function [sectorEmissions, annualEmissions] = Supplementary_Code(dataDir, years)
%SUPPLEMENTARY_CODE Calculate GHG emissions from U.S. weapon manufacturing.
%
% Usage:
%   [sectorEmissions, annualEmissions] = ...
%       Supplementary_Code('path/to/Supplementary data', 2013:2023);
%
% Required input files:
%   5-Emissions_satellite_accounts.xlsx (US_accounts)
%   3-Input_output_tables/3.1-US_Military_Extended_IOTs/updated_MYYYY.xlsx
%
% The function calculates Scope 1, Scope 2, and domestic upstream
% Scope 3 emissions for six weapon-manufacturing sectors using
% military-extended input-output tables and emissions accounts.
% S390 and S391 are combined to obtain 396 sectors.
%
% Monetary values are in million USD; emissions are in tCO2e.
% Outputs are sector-level and annual emissions tables.


if nargin < 1 || isempty(dataDir)
    dataDir = fullfile(fileparts(mfilename('fullpath')), 'Supplementary data');
end
if nargin < 2 || isempty(years)
    years = 2013:2023;
end
validateattributes(years, {'numeric'}, ...
    {'vector', 'integer', '>=', 2013, '<=', 2023}, mfilename, 'years');
years = unique(years(:)).';

accountFile = fullfile(dataDir, '5-Emissions_satellite_accounts.xlsx');
if ~isfile(accountFile)
    error('weaponEmissions:MissingInput', ...
        'Satellite-account file not found: %s', accountFile);
end
account = readcell(accountFile, 'Sheet', 'US_accounts');
accountCodes = string(account(3:end, 1));
sectorNames = string(account(3:end, 2));
yearLabels = string(account(2, 3:13));
n = numel(accountCodes);
if n ~= 397 || numel(unique(accountCodes)) ~= n
    error('weaponEmissions:AccountLayout', ...
        'US_accounts must contain 397 uniquely coded sectors after two header rows.');
end

militaryCodes = "MS" + compose('%03d', (1:6).');
[foundMilitary, military] = ismember(militaryCodes, accountCodes);
electricity = find(accountCodes == "S028");
if ~all(foundMilitary) || numel(electricity) ~= 1
    error('weaponEmissions:SectorCodes', ...
        'Expected military sectors MS001-MS006 and electricity sector S028.');
end

sectorBlocks = cell(numel(years), 1);
annualBlocks = cell(numel(years), 1);
emissionNames = {'Scope1_tCO2e', 'Scope2_tCO2e', ...
    'Scope3Upstream_tCO2e', 'Scope123_tCO2e', ...
    'InternalInputs_tCO2e', 'Scope3UpstreamNoInternal_tCO2e', ...
    'Scope123NoInternal_tCO2e'};

for k = 1:numel(years)
    year = years(k);
    yearColumn = find(yearLabels == string(year));
    if numel(yearColumn) ~= 1
        error('weaponEmissions:Year', 'Satellite account missing year %d.', year);
    end
    directEmissions = cell2mat(account(3:end, yearColumn + 2));
    validateattributes(directEmissions, {'numeric'}, ...
        {'column', 'numel', n, 'finite', 'nonnegative'});

    ioFile = fullfile(dataDir, '3-Input_output_tables', ...
        '3.1-US_Military_Extended_IOTs', sprintf('updated_M%d.xlsx', year));
    if ~isfile(ioFile)
        error('weaponEmissions:MissingInput', 'Input-output file not found: %s', ioFile);
    end
    labels = readcell(ioFile, 'Sheet', 'updated_svalue');
    columnCodes = string(labels(2, 3:n + 2)).';
    columnTypes = string(labels(1, 3:n + 2)).';
    rowCodes = string(labels(3:n + 2, 2));
    rowTypes = string(labels(3:n + 2, 1));
    columnCodes(columnTypes == "M") = "M" + columnCodes(columnTypes == "M");
    rowCodes(rowTypes == "M") = "M" + rowCodes(rowTypes == "M");
    [found, accountOrder] = ismember(columnCodes, accountCodes);
    if ~all(found) || numel(unique(columnCodes)) ~= n || ...
            ~isequal(rowCodes, columnCodes)
        error('weaponEmissions:Alignment', ...
            'Input-output and satellite-account sector codes do not align in %d.', year);
    end

    % C:OI contains the 397 sector columns. Rows include domestic purchases,
    % imported intermediate inputs and value added. Column sums give output.
    io = readmatrix(ioFile, 'Sheet', 'updated_svalue', ...
        'Range', sprintf('C3:OI%d', size(labels, 1)));
    io(isnan(io)) = 0;  % Empty transaction cells represent zero in these files.
    validateattributes(io, {'numeric'}, {'2d', 'size', [NaN, n], 'finite'});
    Z = io(1:n, :);
    output = sum(io, 1).';
    directEmissions = directEmissions(accountOrder);

    % Preserve the original S390/S391 aggregation in every aligned input.
    % This also avoids division by a near-zero S390 output in 2014.
    keepSector = find(columnCodes == "S390");
    dropSector = find(columnCodes == "S391");
    Z(keepSector, :) = Z(keepSector, :) + Z(dropSector, :);
    Z(:, keepSector) = Z(:, keepSector) + Z(:, dropSector);
    Z(dropSector, :) = [];
    Z(:, dropSector) = [];
    output(keepSector) = output(keepSector) + output(dropSector);
    directEmissions(keepSector) = directEmissions(keepSector) + directEmissions(dropSector);
    output(dropSector) = [];
    directEmissions(dropSector) = [];
    columnCodes(dropSector) = [];
    validateattributes(output, {'numeric'}, {'column', 'positive', 'finite'});
    [~, militaryInIO] = ismember(militaryCodes, columnCodes);
    electricityInIO = find(columnCodes == accountCodes(electricity));

    % A_ij = Z_ij / x_j; f_i = g_i / x_i; alpha = f' * (I-A)^(-1).
    % Right division solves the system without explicitly forming an inverse.
    A = Z ./ output.';
    systemMatrix = eye(size(Z, 1)) - A;
    if rcond(systemMatrix) < 1e-12
        error('weaponEmissions:SingularSystem', ...
            'The Leontief system is singular or poorly conditioned in %d.', year);
    end
    directIntensity = directEmissions ./ output;
    embodiedIntensity = directIntensity.' / systemMatrix;

    % Production footprint = direct emissions + embodied purchased inputs.
    scope1 = directEmissions(militaryInIO);
    scope2 = directIntensity(electricityInIO) .* Z(electricityInIO, militaryInIO).';
    embodiedInputs = (embodiedIntensity * Z(:, militaryInIO)).';
    scope3 = embodiedInputs - scope2;
    scope123 = scope1 + scope2 + scope3;

    % Remove internal intermediate-input footprints at the military-system boundary.
    internalInputs = (embodiedIntensity(militaryInIO) * ...
        Z(militaryInIO, militaryInIO)).';
    scope3NoInternal = scope3 - internalInputs;
    scope123NoInternal = scope1 + scope2 + scope3NoInternal;
    values = [scope1, scope2, scope3, scope123, internalInputs, ...
        scope3NoInternal, scope123NoInternal];
    validateattributes(values, {'numeric'}, {'finite'});

    identifiers = table(repmat(year, 6, 1), militaryCodes, ...
        sectorNames(military), output(militaryInIO), ...
        'VariableNames', {'Year', 'Sector', 'SectorName', 'Output_millionUSD'});
    sectorBlocks{k} = [identifiers, array2table(values, 'VariableNames', emissionNames)];
    annualBlocks{k} = [table(year, 'VariableNames', {'Year'}), ...
        array2table(sum(values, 1), 'VariableNames', emissionNames)];
end

sectorEmissions = vertcat(sectorBlocks{:});
annualEmissions = vertcat(annualBlocks{:});
end
