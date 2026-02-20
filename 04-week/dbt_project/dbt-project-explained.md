## Macros
- They behave like Python functions (resuasable logic)
- They help you ecapsulate logic (in one place)

## seeds
- a space to upload csv and flat files (to add them to dbt later) 
- Quick and dirty apporach (better to fix at source)

## snapshots
- 
## tests
- A place to put assetions in sql format
- A place for singular tests
- If this SQL command retunrs more than 0 rows, the dbt build fails
## models


### staging
- Sources (so raw table from database)
- staging files are 1 to 1 copy of your data with minimal cleaning steps
    - Data types
    - Renaming columns

### intermediate
- Anythin that is not raw nor you want to expose
- No guidelines, just nice for heavy duty cleaning or complex logic
### marts
- if it is in marts, it is ready for consumption
- tables ready for dashboards
- Properly modeled, clean tables 