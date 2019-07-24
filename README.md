# Plant Genome-wide Association Study Database Connector (PGWASDBC)

## Installation

Use [devtools](https://cran.r-project.org/web/packages/devtools/index.html) or
[remotes](https://remotes.r-lib.org/) to install the package from GitHub. Below
is an example of how to install the package using `devtools`.

```R
devtools::install_github("tparkerd/pgwasdbc")
```

## Usage

To query the database from your code, you can use the namespace `pgwasdbc`.

Below is a list of the functions available.

### `list_bp_by_liketrait_for_species`(trait, species, cutoff)`
List of SNP number, chromosome, trait, for a species given a p-value cutoff

    trait (string) - name of the trait (case insensitive)
    species (string) - binomial name of species (e.g., 'Zea mays')
    cutoff (numeric) - maximum p-value cutoff, exclusive

### `list_bp_by_trait_for_species`(trait, species, cutoff)`
List of SNP number, chromosome, trait, for a species given a p-value cutoff

    trait (string) - name of the trait (case insensitive)
    species (string) - binomial name of species (e.g., 'Zea mays')
    cutoff (numeric) - maximum p-value cutoff, exclusive

### `list_traits()`
List name of all traits

### `list_species()`
Lists binomial name and shortname for all species

### `list_growouts()`
Lists growout name and location code for all growouts

### `query(sql)`
Execute a SQL statement; allows to running custom queries against the database.
Permitted actions are limited by granted permissions on database for assigned
user.

    sql (string) - SQL statement (e.g., SELECT * FROM species)

### Example of pulling trait data using predefined queries
```R
gwasdbconnector::list_bp_by_liketrait_for_species(trait = "As75", cutoff = 0.01, species = "Zea mays")
```

### Example user-defined query
```R
gwasdbconnector::query("SELECT * from trait")
```

## Troubleshooting

Since this package depends on postgreSQL drivers, you may need to manually
install your operating system's respective Postgres development drivers. 

**Debian, Ubuntu**

    sudo apt install libpq-dev

## Additional Information

Google Doc: [Implementation & Feature Requests](https://docs.google.com/document/d/14YP_kJCvJwtaxx2XFwtKSiZGrJTMMSoc2etRig7xUfI/)