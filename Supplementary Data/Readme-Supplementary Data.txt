README for Supplementary Data

1. Overview

This directory contains datasets supporting the article "Carbon footprints of U.S. weapons". The datasets cover 2013–2023 and include procurement and arms-sales source records, processed product classifications, U.S. military-extended input-output tables, sectoral and regional concordances, and greenhouse-gas emissions satellite accounts.

The directory contains 20 Excel workbooks, one Word document containing the AI coding prompt, and this README. File and directory names below match the deposited files.

2. Folder Structure and File Contents

2.1 1-Arms_sales_datasets/

DOD.xlsx
Source procurement information compiled from official U.S. Department of Defense budget documents. Annual worksheets cover fiscal years 2013–2023 and retain the reported budget-line descriptions and expenditure information used in processing.

FMS.xlsx
Foreign Military Sales information compiled from official announcements and supporting records. Annual worksheets cover 2013–2023. The Shipped_value worksheet provides annual aggregate FMS delivery values and their sources.

DCS.xlsx
Direct Commercial Sales information from officially released export records for 2013–2023. Annual worksheets retain country or territory, export category, quantity and authorized-value information where available. The MAP worksheet provides category definitions.

These files retain source-specific reporting structures and units. The harmonization of procurement expenditures, export authorizations and deliveries is described in the article and Supplementary Information.

2.2 2-Processed_contract_data/

AI prompt.docx
The coding prompt and rules used for NotebookLM-assisted information extraction and preliminary product-sector classification. The document specifies the permitted source materials, required output fields and handling of uncertain items.

AI_process_contract.xlsx
The Sheet worksheet contains product-line descriptions, extracted budget or program information, core deliverables and activities, preliminary AI sector assignments, final manual sector assignments, correction explanations where recorded, and source URLs where supplied. The MAP worksheet defines classification codes AS001–AS006.

DOD_Sector_ProductUse_AllYears.xlsx
Processed DoD procurement line items for fiscal years 2013–2023, including descriptions, monetary values, sector codes and product-use classifications. The MAP worksheet defines the sector codes.

FMS_Sector_ProductUse_AllYears.xlsx
Processed FMS product records for fiscal years 2013–2023, including descriptions, monetary values, sector codes and product-use classifications. The MAP worksheet defines the sector codes.

DCS_with_NewSector_2013_2023.xlsx
DCS records for 2013–2023 with assigned weapon-sector classifications. Annual worksheets retain export categories and reported values together with the NewSector field. The MAP worksheet documents the original DCS category definitions.

Source-record counts, product-classification entries and firm-level order counts refer to different statistical units and processing stages. Their definitions are described in the article and Supplementary Information.

2.3 3-Input_output_tables/3.1-US_Military_Extended_IOTs/

This directory contains eleven annual U.S. military-extended input-output workbooks, named updated_M2013.xlsx through updated_M2023.xlsx. Each workbook contains the updated_svalue worksheet.

The production block contains 397 sectors, comprising 391 ordinary or civilian-sector nodes and six military-sector nodes. Additional rows record imported intermediate inputs and value added. The tables also contain 19 final-demand categories. Monetary values are expressed in million USD.

The first two rows and columns provide transaction-type labels and sector codes. D identifies ordinary or civilian domestic production, M identifies military production, and I identifies imported inputs. The pair M/S001 corresponds to military-sector code MS001 in the emissions account, with the same convention for the other five military sectors.

The six military sectors cover aircraft, missiles, armored vehicles and tanks, ships, ammunition and ordnance, and military electronic equipment. Sector and final-demand definitions are provided in 4-Sector_and_region_concordances.xlsx.

2.4 4-Sector_and_region_concordances.xlsx

This workbook contains four worksheets.

Table 4-1 contains the mapping between the 402-sector and 391-sector U.S. classifications, sector definitions for the military-extended national framework, and final-demand codes.

Table 4-2 maps DoD and FMS product descriptions and DCS categories to weapon-manufacturing sectors.

Table 4-3 contains mappings from the 391 U.S. sectors and 120 GLORIA sectors to the 86 common sector groups, together with common-sector names and codes.

Table 4-4 contains the mapping from 164 GLORIA regions to 32 aggregated regions and lists their names and acronyms.

2.5 5-Emissions_satellite_accounts.xlsx

This workbook contains annual direct greenhouse-gas emissions for 2013–2023, expressed in tonnes of CO2 equivalent (tCO2e), in the US_accounts worksheet.

US_accounts contains the account for 397 U.S. production sectors. S001–S391 identify ordinary or civilian-sector nodes, and MS001–MS006 identify military-sector nodes.

This account supplies direct-emissions inputs. Scope 2 and upstream Scope 3 emissions are derived through input-output calculations.

3. Relationship to the Calculation Code

The MATLAB function Supplementary_Code.m is located in the repository's Supplementary Code directory. It reads the US_accounts worksheet and the annual updated_MYYYY.xlsx workbooks.

The function aligns sector codes and combines S390 and S391 consistently across transactions, outputs and emissions, resulting in a 396-sector calculation system. It calculates Scope 1, Scope 2 and domestic upstream Scope 3 emissions for six weapon-manufacturing sectors, including an adjustment for intermediate transactions among those sectors.

The repository's main README provides calling commands and output definitions. Methods and accounting boundaries for global supply chains, product-use emissions, projections and sensitivity analyses are described in the article and Supplementary Information.

4. Data Format and Usage

Excel files are provided in .xlsx format, and the AI prompt is supplied in .docx format. Preserve directory names and file names when using the supplied MATLAB function.

Consult the column headings for monetary units in procurement and arms-sales records. Input-output table values are in million USD, and satellite-account emissions are in tCO2e. Blank transaction cells in the national input-output tables are treated as zero by the supplied function.

Figure-specific numerical data are provided in the separate Source data directory. Supplementary Tables S1–S7 are in Supplementary Table/Supplementary_Tables.xlsx.
