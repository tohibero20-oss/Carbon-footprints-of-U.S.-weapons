# Carbon footprints of U.S. weapons

Data and code supporting the research article **Carbon footprints of U.S. weapons**.

This repository contains figure source data, supplementary tables, procurement and arms-sales datasets, U.S. military-extended input-output tables, emissions satellite accounts, and a MATLAB routine for calculating production-related greenhouse-gas emissions.

Historical datasets cover 2013–2023. Figure source data also include emissions projections through 2050 and the sensitivity analyses reported in the article. Detailed methods, assumptions and accounting boundaries are described in the article and its Supplementary Information.

## Repository contents

```text
Carbon-footprints-of-U.S.-weapons/
├── Source data/
│   ├── Source_Data_Fig_1.xlsx ... Source_Data_Fig_6.xlsx
│   ├── Source_Data_Extended_Fig_2.xlsx ... Source_Data_Extended_Fig_5.xlsx
│   └── Readme-Source data.txt
├── Supplementary Code/
│   └── Supplementary_Code.m
├── Supplementary Data/
│   ├── 1-Arms_sales_datasets/
│   │   ├── DOD.xlsx
│   │   ├── FMS.xlsx
│   │   └── DCS.xlsx
│   ├── 2-Processed_contract_data/
│   │   ├── AI prompt.docx
│   │   ├── AI_process_contract.xlsx
│   │   ├── DOD_Sector_ProductUse_AllYears.xlsx
│   │   ├── FMS_Sector_ProductUse_AllYears.xlsx
│   │   └── DCS_with_NewSector_2013_2023.xlsx
│   ├── 3-Input_output_tables/
│   │   └── 3.1-US_Military_Extended_IOTs/
│   │       └── updated_M2013.xlsx ... updated_M2023.xlsx
│   ├── 4-Sector_and_region_concordances.xlsx
│   ├── 5-Emissions_satellite_accounts.xlsx
│   └── Readme-Supplementary Data.txt
├── Supplementary Table/
│   ├── Supplementary_Tables.xlsx
│   └── Readme-Supplementary Table.txt
└── README.md
```

### Figure source data

[Source data](Source%20data/) contains ten Excel files, each with one worksheet corresponding to a main or Extended Data figure.

| File | Contents |
| --- | --- |
| `Source_Data_Fig_1.xlsx` | Historical and projected emissions, and emission intensities by weapon product category. |
| `Source_Data_Fig_2.xlsx` | Emissions associated with domestic demand and exports, with firm-, channel- and product-level summaries. |
| `Source_Data_Fig_3.xlsx` | Geographic and product-level distributions of export-related emissions and international emission flows. |
| `Source_Data_Fig_4.xlsx` | Annual emissions of representative weapon products by company and purchaser. |
| `Source_Data_Fig_5.xlsx` | Emissions projections and comparisons with climate-target pathways and selected hard-to-abate sectors. |
| `Source_Data_Fig_6.xlsx` | Sensitivity analyses of input-output construction, emission intensities and future projections. |
| `Source_Data_Extended_Fig_2.xlsx` | Annual emissions associated with domestic arms demand. |
| `Source_Data_Extended_Fig_3.xlsx` | Annual emissions associated with arms exports. |
| `Source_Data_Extended_Fig_4.xlsx` | Weapon-sales data and firm-, channel- and product-level summaries. |
| `Source_Data_Extended_Fig_5.xlsx` | Export-related emission flows by destination and weapon product category. |

Extended Data Figure 1 is a workflow diagram and has no separate numerical source data file. Panel-level definitions are described in the [source-data README](Source%20data/Readme-Source%20data.txt) and the article's figure legends.

### Supplementary data

[Supplementary Data](Supplementary%20Data/) contains source and processed procurement and arms-sales records, the NotebookLM coding prompt, annual U.S. military-extended input-output tables for 2013–2023, sectoral and regional concordances, and emissions satellite accounts.

The input-output workbooks contain 397 domestic production sectors, imported intermediate-input rows, value added and final-demand columns. The emissions workbook contains the `US_accounts` and `GLORIA_accounts` worksheets. **This repository version includes the national input-output tables. The annual U.S.–GLORIA nested MRIO table files described in the accompanying supplementary-data README are absent from this version.**

### Supplementary tables

[Supplementary_Tables.xlsx](Supplementary%20Table/Supplementary_Tables.xlsx) contains seven worksheets corresponding to Supplementary Tables S1–S7. They cover emissions reported for selected conflicts, emissions of low-income countries, sector classifications, product-sector mappings, sectoral and regional concordances, company emission intensities, and geographic abbreviations.

## Running the MATLAB calculation

### Requirements

The calculation requires MATLAB with the built-in spreadsheet-reading, string-array and table functions used in `Supplementary_Code.m`. The function invokes no additional MATLAB toolboxes. Spreadsheet files can be inspected using Excel or compatible software.

Download the repository and retain its directory structure. In MATLAB, set the Current Folder to the repository root, then run:

```matlab
repoRoot = pwd;
addpath(fullfile(repoRoot, 'Supplementary Code'));
dataDir = fullfile(repoRoot, 'Supplementary Data');

[sectorEmissions, annualEmissions] = Supplementary_Code(dataDir, 2013:2023);
```

To calculate one year, use:

```matlab
[sectorEmissions, annualEmissions] = Supplementary_Code(dataDir, 2023);
```

Pass `dataDir` explicitly as shown above to match the repository layout. The function's no-argument default searches for a data directory inside the code directory.

The function reads two types of input:

- `5-Emissions_satellite_accounts.xlsx`, worksheet `US_accounts`.
- `3-Input_output_tables/3.1-US_Military_Extended_IOTs/updated_MYYYY.xlsx`, worksheet `updated_svalue`, for each requested year.

The satellite account supplies prepared direct emissions in CO2-equivalent units. Sector codes align the account with the input-output tables. The national-table labels `M` and `S001`–`S006` correspond to satellite-account codes `MS001`–`MS006`. The function then combines sectors S390 and S391 consistently in the transactions, outputs and emissions account, giving a 396-sector calculation system. Electricity is identified by sector code S028.

### Outputs and accounting scope

The function returns two MATLAB tables. `sectorEmissions` contains six sector records per requested year. `annualEmissions` sums the six sectors for each year. Running all eleven years returns 66 sector records and 11 annual records.

| Output field | Meaning |
| --- | --- |
| `Year` | Accounting year. |
| `Sector`, `SectorName` | Military-sector code and name, provided in the sector table. |
| `Output_millionUSD` | Sector output in million USD, provided in the sector table. |
| `Scope1_tCO2e` | Direct emissions. |
| `Scope2_tCO2e` | Emissions attributed to purchased electricity. |
| `Scope3Upstream_tCO2e` | Domestic upstream emissions embodied in intermediate inputs, excluding Scope 2. |
| `Scope123_tCO2e` | Sum of Scope 1, Scope 2 and upstream Scope 3 before the internal-input adjustment. |
| `InternalInputs_tCO2e` | Embodied emissions of intermediate inputs exchanged among the six military sectors. |
| `Scope3UpstreamNoInternal_tCO2e` | Upstream Scope 3 after subtracting internal-input embodied emissions. |
| `Scope123NoInternal_tCO2e` | Total production footprint after the internal-input adjustment. |

Use the `NoInternal` fields when examining the military-system aggregate with the internal-input adjustment. Emission outputs are in tonnes of CO2 equivalent (tCO2e). Divide by 1,000,000 to express them in MtCO2e.

The supplied function calculates Scope 1, Scope 2 and domestic upstream Scope 3 emissions for six weapon-manufacturing sectors. Foreign supply-chain accounting, downstream product-use emissions, future projections and sensitivity analyses require the additional methods described in the article. The function's outputs therefore cover a narrower accounting boundary than figures that include these components.

Results remain in the MATLAB workspace. For an optional CSV export:

```matlab
writetable(sectorEmissions, 'sector_emissions.csv');
writetable(annualEmissions, 'annual_emissions.csv');
```

## Data interpretation and citation

Units and accounting boundaries vary across figures and data sections. Consult the file headings, figure legends and Supplementary Information before comparing totals. Company identifiers such as AF1 and AF2 follow the anonymized codes used in the article.

When using these materials, cite **Carbon footprints of U.S. weapons** and acknowledge the original data sources relevant to the analysis. Source references and descriptions are provided in the article, Supplementary Information and the documentation accompanying the datasets.
