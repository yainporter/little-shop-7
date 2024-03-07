# Little Esty Shop

## Project Description
This a brownfield solo project for Mod 2 of Turing School of Software & Design's backend program that focuses on Ruby and Ruby on Rails forked from my group project. This final focuses on creating a Bulk Discount table in our PostgreSQL database that applies discounts to an e-commerce store, and making Active Record queries.

## Other README's
Original repo's [README](https://github.com/turingschool-examples/little-shop-7/blob/main/README.md)

Group project repo's [README](https://github.com/kohljd/little-shop-7/blob/main/README.md)

## User Stories
```
1: Merchant Bulk Discounts Index

As a merchant
When I visit my merchant dashboard
Then I see a link to view all my discounts
When I click this link
Then I am taken to my bulk discounts index page
Where I see all of my bulk discounts including their
percentage discount and quantity thresholds
And each bulk discount listed includes a link to its show page
```

```
2: Merchant Bulk Discount Create

As a merchant
When I visit my bulk discounts index
Then I see a link to create a new discount
When I click this link
Then I am taken to a new page where I see a form to add a new bulk discount
When I fill in the form with valid data
Then I am redirected back to the bulk discount index
And I see my new bulk discount listed
```

```
3: Merchant Bulk Discount Delete

As a merchant
When I visit my bulk discounts index
Then next to each bulk discount I see a button to delete it
When I click this button
Then I am redirected back to the bulk discounts index page
And I no longer see the discount listed
```

```
4: Merchant Bulk Discount Show

As a merchant
When I visit my bulk discount show page
Then I see the bulk discount's quantity threshold and percentage discount
```

```
5: Merchant Bulk Discount Edit

As a merchant
When I visit my bulk discount show page
Then I see a link to edit the bulk discount
When I click this link
Then I am taken to a new page with a form to edit the discount
And I see that the discounts current attributes are pre-poluated in the form
When I change any/all of the information and click submit
Then I am redirected to the bulk discount's show page
And I see that the discount's attributes have been updated
```

```
6: Merchant Invoice Show Page: Total Revenue and Discounted Revenue

As a merchant
When I visit my merchant invoice show page
Then I see the total revenue for my merchant from this invoice (not including discounts)
And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation

Note: We encourage you to use as much ActiveRecord as you can, but some Ruby is okay. Instead of a single query that sums the revenue of discounted items and the revenue of non-discounted items, we recommend creating a query to find the total discount amount, and then using Ruby to subtract that discount from the total revenue.

For an extra spicy challenge: try to find the total revenue of discounted and non-discounted items in one query!
```

```
7: Merchant Invoice Show Page: Link to applied discounts

As a merchant
When I visit my merchant invoice show page
Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
```

```
8: Admin Invoice Show Page: Total Revenue and Discounted Revenue

As an admin
When I visit an admin invoice show page
Then I see the total revenue from this invoice (not including discounts)
And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
```

## Reflections On Learning Goals:


## Database Schema
![alt text](https://github.com/kohljd/little-shop-7/blob/main/doc/little_esty_shop_db_diagram.png?raw=true)

## Server Application & Database
- Rails 7.1.x, Ruby 3.2.2
- PostgreSQL
