# YAML Tables

For the most part, we really like markdown. However, we don't like markdown
tables. Any of them. So, what did we do? Make yet another way of doing them.

![](https://imgs.xkcd.com/comics/standards.png)

In the most basic form, they look like this:

````
```table
- Column 1: row1col1
  Column 2: row1col2
  Column 3: row1col3
- Column 1: row2col1
  Column 3: row2col3
  Column 2: row2col2
```
````

![](../images/2025-06-13-14-15-26.png)



These yaml tables have a number of options.

Adding the class `transpose`, as below, will transpose the table so the left
most column is highlighted blue rather than the top row. For example:

````
```{.table .transpose}
Row 1: Data 1
Row 2: Data 2
Row 3: Data 3
```
````

![](./images/2025-06-13-14-33-31.png)

## Alignment / Width

In latex, these alignment options also determine the width of table columns.

`X`, `Y` and `Z` will align text left, centre and right respectively. Any
columns with these alignments will have equal width based on remaining space.

`x`, `y` and `z` will also align text left, centre and right respectively.
However, the width of the cell is determined by the contents of a cell.

Lastly `L[*]`, `C[*]` and `R[*]` will also align text left, centre and right
respectively. However, the width of the cell is determined by the width
specified in the brackets.


So, for example,

````
```{.table .transpose align=xX}
col1row1: col2row1
col1row2: col2row2
```
````

![](./images/2025-06-13-14-37-16.png)

## Header Rotation


Adding `rotateHeader` to the class list will result in the table headers being
written sideways in order to fit more columns in.

````
```{.table align=YYY .rotateHeader}
- Column 1: row1col1
  Column 2: row1col2
  Column 3: row1col3
- Column 1: row2col1
  Column 3: row2col3
  Column 2: row2col2
```
````

![](./images/2025-06-13-14-40-11.png)


