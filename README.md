# **NEAR Blockchain Explorer**
This is a **Rails 8** application that fetches and displays transactions from a simulated **NEAR blockchain API**. The application **stores transactions in an SQLite database**, ensuring historical data remains available even if it's no longer returned by the API.

## **Features**
- Fetches blockchain transactions via the provided API
- Stores transactions in a **SQLite** database
- Displays the latest **50 transactions** in a **table view**
- Background job processing using **Sidekiq & Redis**
- Periodic transaction fetching using **`sidekiq-cron`**
- Fully tested with **Minitest** (Service + Controller)

---

## ** Setup Instructions**
### ** Install Dependencies **
Ensure you have **Ruby 3.2+**, **Rails 8**, and **Redis** installed.

```sh
git clone https://github.com/YOUR_USERNAME/near-explorer.git
cd blockchain_transactions
bundle install

**Set Up the Database (SQLite):**

rails db:create
rails db:migrate

**Start Redis & Sidekiq:**

redis-server # If running locally
bundle exec sidekiq

**Start the Rails Server:**

rails server

Visit http://localhost:3000/ to see the transaction list.
  Tech Stack

    Backend: Ruby on Rails 8
    Database: SQLite (Lightweight, built-in)
    Background Jobs: Sidekiq + Redis
    Testing: Minitest

**Design Decisions & Tradeoffs**
  Pros of My Approach

    Encapsulation:
        I moved API calls to NearApiService, keeping controllers thin.
        Background jobs handle API fetching via FetchTransactionsJob, preventing slow page loads.

    Performance:
        Transactions are stored in the database, reducing API dependency.
        Indexing transaction_hash ensures fast lookups and prevents duplicates.

    Reliability:
        Sidekiq automatically retries failed jobs (e.g., API failures).
        Redis ensures job queue persistence, preventing lost transactions.

    SQLite Instead of PostgreSQL:
        Pros: Simple setup, no external database required, works out of the box with Rails.
        Cons: Less scalable for high-volume transactions (would switch to PostgreSQL/MySQL in production).

**Potential Improvements**

If I had more time, I would:

    Add Pagination
        Currently, I only display 50 transactions. I would use kaminari or pagy for efficient pagination.

    Implement Filtering & Sorting
        Users should be able to filter transactions by:
            Sender/Receiver
            Date Range
            Min/Max Deposit
        Sorting should allow:
            Newest to oldest
            Highest deposit first

    Improve UI
        Add TailwindCSS or Bootstrap for better styling.
        Make the transaction hash a clickable link.

    Cache API Responses
        Use Rails.cache to reduce API calls & improve performance.

**Running Tests**

rails test

**Tests Included**

    Service Tests: Ensures NearApiService correctly parses API data.
    Controller Tests: Ensures transactions load & display correctly.

**API Assumptions**

    The API only returns the latest transactions.
    Only transactions of type Transfer are stored.
    The API may be down, so Sidekiq retries failures automatically.
