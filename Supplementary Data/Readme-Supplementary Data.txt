README for Source Data Related to the Manuscript Submission

1. Overview

This supplementary data package contains the key datasets used in the manuscript, including the military-extended input-output tables, cleaned military procurement and arms-sales records, sector concordance tables, and greenhouse gas emissions satellite accounts. The files are provided to improve the transparency, traceability, and reproducibility of the data processing and quantitative analysis reported in the manuscript. The data package covers the period 2013–2023.


2. Folder Structure and File Contents

2.1 Arms-sales datasets/

This folder contains the arms-sales datasets used in the analysis:

- DOD.xlsx
- FMS.xlsx
- DCS.xlsx

The DoD and DCS datasets were obtained from officially released records. The FMS dataset was manually compiled from publicly available news releases and related official announcements. These files provide the source information used to identify and classify domestic military procurement, Foreign Military Sales (FMS), and Direct Commercial Sales (DCS) during the study period.

2.2 Processed contract data/

This folder contains cleaned and processed versions of the military procurement and arms-sales records. The records were classified by product type and mapped to the corresponding military sectors used in the input–output analysis. Supporting files document the information-extraction, classification, and validation procedures.

2.2.1 AI prompt.docx

This document records the prompt, classification criteria, and instructions used for large-language-model-assisted information extraction and preliminary sector assignment. The model-assisted classifications were subsequently checked and validated during data processing.

2.2.2 AI_process_contract.xlsx

This workbook contains the cleaned contract records and their assigned product and sector classifications. It also includes the mapping information used to connect individual contract descriptions with the corresponding arms-manufacturing sectors.

2.2.3 DOD_Sector_ProductUse_AllYears.xlsx

This workbook contains the processed U.S. Department of Defense (DoD) procurement records for fiscal years 2013–2023. The annual worksheets report the cleaned line-item descriptions, assigned arms-manufacturing sectors, and product-use classifications. The mapping worksheet documents the concordance applied during classification.

2.2.4 FMS_Sector_ProductUse_AllYears.xlsx

This workbook contains the processed Foreign Military Sales (FMS) records for fiscal years 2013–2023. The annual worksheets report the cleaned sales records, assigned arms-manufacturing sectors, and product-use classifications. The mapping worksheet documents the sector-assignment rules.

2.2.5 DCS_with_NewSector_2013_2023.xlsx

This workbook contains the processed Direct Commercial Sales (DCS) records for 2013–2023. The annual worksheets report DCS records and their assigned arms-manufacturing sectors. The mapping worksheet provides the concordance between DCS categories and the six military product sectors.


2.3 Input-output tables/

This folder contains the annual input–output tables used in the national and global stages of the analysis. It is divided into two subfolders, each containing 11 annual Excel workbooks covering 2013–2023.

2.3.1 US Military-extended IOTs/

This subfolder contains 11 annual U.S. military-extended, non-competitive input–output tables:

- updated_MYYYY.xlsx, where YYYY = 2013, 2014, ..., 2023

Each workbook contains the U.S. input–output table for the corresponding year after six military sectors were separated from their parent industries. The tables distinguish domestic intermediate transactions, imported intermediate inputs, final demand, value added, and related accounting components. The sector and final-demand codes used in these tables are documented in Sector_and_regional_concordances.xlsx.

The tables were constructed from the U.S. national input–output accounts and reconciled using the procedures described in the Supplementary Information. They provide the national accounting framework used to estimate U.S. domestic military production and supply-chain emissions.

2.3.2 US-GLORIA Nested MRIOs/

This subfolder contains 11 annual military-extended multiregional input–output (MRIO) tables nested within the GLORIA framework:

- USMRIO_Output_YYYY.xlsx, where YYYY = 2013, 2014, ..., 2023

These workbooks integrate the U.S. military-extended input–output tables into the harmonized GLORIA MRIO system. The global framework contains 32 regions and 86 common sectors, while the U.S. block retains six additional military sectors. U.S.-linked intermediate and final-demand flows are reconstructed using the U.S. national table together with military-specific import and export allocation information, whereas non-U.S.-to-non-U.S. flows retain the corresponding GLORIA structure. The annual MRIO tables are used to trace domestic and foreign supply-chain emissions associated with U.S. military production.


2.4 Sector and regional concordances.xlsx

This workbook contains the sectoral and regional concordances used to harmonize the U.S. national input–output accounts with the GLORIA framework. It documents the mappings between the detailed U.S. sector classification and the 86 common sectors, between the original GLORIA sector classification and the 86 common sectors, and between the original GLORIA regions and the 32-region classification used in the nested MRIO framework. It also provides the names and codes of the harmonized sectors and regions and identifies the six U.S.-specific military sectors.

These concordances are used to align economic accounts, military procurement and arms-sales records, trade flows, and emissions data across the national and global models.


2.5 Emissions satellite accounts.xlsx

This workbook contains the GHG emissions satellite accounts matched to the sectoral and regional structure of the input–output tables. It provides the direct emissions information used to construct sectoral emission intensities and to estimate Scope 1, Scope 2, and upstream Scope 3 emissions in the national and nested MRIO analyses.


3. Data Format and Usage

All Excel files are provided in .xlsx format and can be opened using Microsoft Excel or other compatible spreadsheet software. The files are intended to support transparency and reproducibility of the manuscript results by documenting the processed datasets and sector assignments used to construct the military-extended input-output tables.
