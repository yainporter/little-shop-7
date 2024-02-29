# Little Esty Shop
Link to original repo's [README](https://github.com/turingschool-examples/little-shop-7/blob/main/README.md)
## Project Description
This project mimics an e-commerce web application with basic CRUD operations, mimicking the functionalities of a Merchant user, and an Admin user. We were able to implement all of the required User Stories with 100% test coverage using `simplecov` on models and features separately.

#### Tasks completed besides User Stories:
- Implement a CSV task to generate our `seeds.rb`
- Implement `Faker` and `Factory Bot` gems to populate test data
- Convert SQL queries to Active Record
- Create a landing page
- Sad path & edge case testing
- Refactoring advanced routing
- CSS styling

#### Tasks that we would work on if we had more time:
- More use of refactoring views to use partials where possible
- Possibly more edge case scenarios
- More CSS styling

## Group Members:
- [Barry's Github](https://github.com/BarryA)
- [Jess's Github](https://github.com/kohljd)
- [Joey's Github](https://github.com/JRIV-10)
- [Lance's Github](https://github.com/LJ9332)
- [Yain's Github](https://github.com/yainporter)

## Tools Used
- [GitHub Projects](https://github.com/users/kohljd/projects/5)
  - We chose to use GitHub Projects to carry out the implementation of practicing agile methodologies because we enjoyed the convenience of having our PRs easily linked by issues, allowing for automation of checking off tasks when a PR is approved.
- GitHub Template
  - We made use of a GitHub PR template that [Jess](https://github.com/kohljd/little-shop-7/pull/97) made based off [Turing's Mod 3 template](https://backend.turing.edu/module3/projects/pr_template) that helped us to make more meaningful PR requests and comments. Prior to using a PR template in previous projects, we were just going through the motions. However having the guidance of a template directed us to focus on taking time to reflect on our work. Also having a section to add a fun fact in the template helped to strengthen the team cohesion.
- Active Record ORM - PostgreSQL
  - While most of us prefer having a visual image of our queries using SQL, we also wanted to be proficient in making advanced database queries and calculations. We used SQL as a stepping stone to help us understand and create more accurate ActiveRecord queries.
- Heroku
  - We chose Heroku for deployment since we had student credits from our school, and it was a fairly seamless transition to get our repo up and running.
- [dbdiagram.io](https://dbdiagram.io/home)
  - Some of us are visual learners, and using dbdiagram to help us envision the database and see the relationships between tables was also another great stepping stone to understanding our ActiveRecord queries.


## Reflections On Learning Goals:

#### &#x2714; Remote teamwork and communication with meaningful PR reviews and comments
- Reviewing code that was written by different team members with their own unique styles was a great learning opportunity for us. Taking the time to stop to make sense of another developer's logic helped to expand our own individual knowledge.

#### &#x2714; Implementing agile methodologies using GitHub Projects
- We were able to stay on top of tracking our progress, and having our GitHub Project tied to our GitHub Repo was extremely beneficial in helping to move our tasks to done on approval of a PR.

#### &#x2714; RESTful routing with nested resources and namespacing
  - We are particularly happy with our routes, since we discovered that a way to get rid of the automatic `puts verb` created along side the `patch verb` with `resources ... :update` by using the `via: [:patch]` syntax

#### &#x2714; Adhering to the model-view-controller architecture
  - We had differing opinions on MVC gray areas like whether or not some view logic should be encapsulated together in a model, or stay strictly in the view, but it was a great opportunity to practice solving team disagreements by discussing and presenting each side's logic

#### &#x2714; Designing a normalized database with defined model relationships
  - This one was fairly simple since we already had the database designed from the csv files, and implementing our schema into dbdiagram just really nailed this concept home for us

#### &#x2714; Utilizing the ActiveRecord ORM to perform complex queries to the database
  - This was honestly the most time consuming and difficult part of the entire project, but it leaves us with a great sense of accomplishment to know that we were able to transform our original SQL queries into working AR queries.

#### &#x2714; Deploying repo to Heroku
  - Most of us thought that we would run into a lot more difficulty with deploying our database and maintaining it, but we surprisingly didn't run into any issues here

## Database Schema
![alt text](https://github.com/kohljd/little-shop-7/blob/main/doc/little_esty_shop_db_diagram.png?raw=true)

## Server Application & Database
- Rails 7.1.x, Ruby 3.2.2
- PostgreSQL
