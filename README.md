# GWAS Database Connector

## Installation

Use [devtools](https://cran.r-project.org/web/packages/devtools/index.html) or
[remotes](https://remotes.r-lib.org/) to install the package from GitHub. Below
is an example of how to install the package using `devtools`.

```R
devtools::install_github("tparker/deathly-parsley")
```

## Usage

To query the database from your code, you can use the namespace `gwasdbconnector`.

Below is a list of the functions available.

### `list_bp_by_liketrait_for_species`(trait, species, cutoff)`
    trait (string) - name of the trait
    species (string) - binomial name of species (e.g., 'Zea mays')
    cutoff (numeric) - maximum p-value cutoff, exclusive

### `list_bp_by_trait_for_species`(trait, species, cutoff)`
### `list_traits()`
### `query(sql)`

### Example of pulling trait data using predefined queries
```R
gwasdbconnector::list_bp_by_liketrait_for_species(trait = "As75", cutoff = 0.01, species = "Zea mays")
```

### Example user-defined query
```R
gwasdbconnector::query("SELECT * from trait")
```

Additional information can be found here: https://docs.google.com/document/d/14YP_kJCvJwtaxx2XFwtKSiZGrJTMMSoc2etRig7xUfI/

## Troubleshooting

Since this package depends on postgreSQL drivers, you may need to manually

    sudo apt install libpq-dev
