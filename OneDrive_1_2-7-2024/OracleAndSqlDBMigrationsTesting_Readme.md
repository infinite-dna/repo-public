Author Stan Zvenigorodskiy email: stanislav.zvenigorodskiy@infinite.com

Checking the size of an Oracle database and verifying that all tables are identical between the on-premises and Azure databases involves more advanced logic. Below is an extended example of a Go test script

 (`oracle_migration_test.go`) that includes functions to check the database size and compare all tables' structure.

Make sure to set the necessary environment variables before running the test:

```bash
export ON_PREM_ORACLE_CONNECTION_STRING="on_prem_oracle_connection_string"
export ON_PREM_ORACLE_USERNAME="on_prem_username"
export ON_PREM_ORACLE_PASSWORD="on_prem_password"

export AZURE_ORACLE_CONNECTION_STRING="azure_oracle_connection_string"
export AZURE_ORACLE_USERNAME="azure_username"
export AZURE_ORACLE_PASSWORD="azure_password"
```

Now, the extended Go test script:

```go
package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"testing"

	_ "github.com/godror/godror" // Import Oracle driver
)

// TestOracleMigration checks if the migration from on-premises Oracle DB to Azure Oracle DB is successful.
func TestOracleMigration(t *testing.T) {
	// Set on-premises Oracle database connection details
	onPremConnectionString := os.Getenv("ON_PREM_ORACLE_CONNECTION_STRING")
	onPremUsername := os.Getenv("ON_PREM_ORACLE_USERNAME")
	onPremPassword := os.Getenv("ON_PREM_ORACLE_PASSWORD")

	// Connect to the on-premises Oracle database
	onPremDB, err := sql.Open("godror", fmt.Sprintf("%s/%s@%s", onPremUsername, onPremPassword, onPremConnectionString))
	if err != nil {
		t.Fatalf("Error connecting to the on-premises Oracle database: %v", err)
	}
	defer onPremDB.Close()

	// Set Azure Oracle database connection details
	azureConnectionString := os.Getenv("AZURE_ORACLE_CONNECTION_STRING")
	azureUsername := os.Getenv("AZURE_ORACLE_USERNAME")
	azurePassword := os.Getenv("AZURE_ORACLE_PASSWORD")

	// Connect to the Azure Oracle database
	azureDB, err := sql.Open("godror", fmt.Sprintf("%s/%s@%s", azureUsername, azurePassword, azureConnectionString))
	if err != nil {
		t.Fatalf("Error connecting to the Azure Oracle database: %v", err)
	}
	defer azureDB.Close()

	// Check if migration is successful
	if err := checkMigration(onPremDB, azureDB); err != nil {
		t.Errorf("Database migration check failed: %v", err)
	}
}

func checkMigration(onPremDB, azureDB *sql.DB) error {
	// Check if the size of the databases is identical
	onPremSize, err := getDatabaseSize(onPremDB)
	if err != nil {
		return fmt.Errorf("error getting on-premises database size: %v", err)
	}

	azureSize, err := getDatabaseSize(azureDB)
	if err != nil {
		return fmt.Errorf("error getting Azure database size: %v", err)
	}

	if onPremSize != azureSize {
		return fmt.Errorf("database sizes are not identical: on-premises=%d, Azure=%d", onPremSize, azureSize)
	}

	// Check if all tables are identical
	if err := compareAllTables(onPremDB, azureDB); err != nil {
		return fmt.Errorf("table comparison failed: %v", err)
	}

	return nil
}

func getDatabaseSize(db *sql.DB) (int64, error) {
	// Add your logic here to calculate the size of the Oracle database
	// You can execute SQL queries to gather information about the database size

	// Example: Execute a query to get the total size of the database in bytes
	query := "SELECT SUM(bytes) FROM dba_segments"
	var size int64
	if err := db.QueryRow(query).Scan(&size); err != nil {
		return 0, fmt.Errorf("error getting database size: %v", err)
	}

	return size, nil
}

func compareAllTables(onPremDB, azureDB *sql.DB) error {
	// Add your logic here to compare all tables between the on-premises and Azure Oracle databases
	// You may want to compare table structures, column types, and constraints

	// Example: Execute a query to get all table names in both databases
	onPremTables, err := getTableNames(onPremDB)
	if err != nil {
		return fmt.Errorf("error getting on-premises table names: %v", err)
	}

	azureTables, err := getTableNames(azureDB)
	if err != nil {
		return fmt.Errorf("error getting Azure table names: %v", err)
	}

	// Compare table names
	if len(onPremTables) != len(azureTables) {
		return fmt.Errorf("number of tables is different: on-premises=%d, Azure=%d", len(onPremTables), len(azureTables))
	}

	// Compare table structures (columns, data types, constraints, etc.)
	for _, tableName := range onPremTables {
		if err := compareTableStructure(onPremDB, azureDB, tableName); err != nil {
			return fmt.Errorf("table structure comparison failed for table %s: %v", tableName, err)
		}
	}

	return nil
}

func getTableNames(db *sql.DB) ([]string, error) {
	// Add your logic here to retrieve all table names from the Oracle database
	// You can execute SQL queries to get a list of table names

	// Example: Execute a query to get all table names from the user's schema
	query := "SELECT table_name FROM user_tables"
	rows, err := db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("error getting table names: %v", err)
	}
	defer rows.Close()

	var tableNames []string
	for rows.Next() {
		var tableName string
		if err := rows.Scan(&tableName); err != nil {
			return nil, fmt.Errorf("error scanning table names: %v", err)
		}
		tableNames = append(tableNames, tableName)
	}

	return tableNames, nil
}

func compareTableStructure(onPremDB, azureDB *sql.DB, tableName string) error {
	// Add your logic here to compare the structure of a specific table between the on-premises and Azure Oracle databases
	// You may want to compare column names, data types, constraints, etc.

	// Example: Execute queries to get information about table structure
	onPremColumns, err := getTableColumns(onPremDB, tableName)
	if err != nil {
		return fmt.Errorf("error getting on-premises table columns for %s: %v", tableName, err)
	}

	azureColumns, err := getTableColumns(azureDB, tableName)
	if err != nil {
		return fmt.Errorf("error getting Azure table columns for %s: %v", tableName, err)
	}

	// Compare column names and data types
	if len(onPremColumns) != len(azureColumns) {
		return fmt.Errorf("number of columns is different for table %s: on-premises=%d, Azure=%d", tableName, len(onPremColumns), len(azureColumns))
	}

	for i := range onPremColumns {
		if onPremColumns[i] != azureColumns[i] {


	return fmt.Errorf("column %s is different for table %s: on-premises=%s, Azure=%s", onPremColumns[i], tableName, onPremColumns[i], azureColumns[i])
		}
	}

	// Add more comparisons based on your requirements (e.g., constraints, indexes, etc.)

	return nil
}

func getTableColumns(db *sql.DB, tableName string) ([]string, error) {
	// Add your logic here to retrieve column names and data types for a specific table from the Oracle database
	// You can execute SQL queries to get information about table columns

	// Example: Execute a query to get column names and data types for a specific table
	query := "SELECT column_name || ' ' || data_type FROM user_tab_columns WHERE table_name = :tableName"
	rows, err := db.Query(query, sql.Named("tableName", tableName))
	if err != nil {
		return nil, fmt.Errorf("error getting table columns for %s: %v", tableName, err)
	}
	defer rows.Close()

	var columns []string
	for rows.Next() {
		var column string
		if err := rows.Scan(&column); err != nil {
			return nil, fmt.Errorf("error scanning table columns for %s: %v", tableName, err)
		}
		columns = append(columns, column)
	}

	return columns, nil
}

func TestMain(m *testing.M) {
	// Set up any test fixtures or environment before running the tests
	// ...

	// Run the tests
	exitCode := m.Run()

	// Clean up or perform additional actions after tests are complete
	// ...

	os.Exit(exitCode)
}
```

This extended script includes the following:

- A `getDatabaseSize` function to calculate the size of an Oracle database.
- A `compareAllTables` function to compare all tables between the on-premises and Azure Oracle databases.
- A `getTableNames` function to retrieve all table names from an Oracle database.
- A `compareTableStructure` function to compare the structure of a specific table between the on-premises and Azure Oracle databases.
- A `getTableColumns` function to retrieve column names and data types for a specific table from an Oracle database.

These functions provide a foundation for more detailed comparisons, and you can extend them based on your specific requirements. Ensure that the queries and logic match your database schema and migration steps.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

				Test for SQL Always On

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Setting up a comprehensive test for SQL Always On databases involves several considerations, including connectivity, data synchronization, and comparing database structures. Below is an example Go test script (`sql_always_on_test.go`) that checks the success of migration and compares SQL Always On databases between on-premises and Azure.

Make sure to set the necessary environment variables before running the test:

```bash
export ON_PREM_SQL_CONNECTION_STRING="on_prem_sql_connection_string"
export ON_PREM_SQL_USERNAME="on_prem_sql_username"
export ON_PREM_SQL_PASSWORD="on_prem_sql_password"

export AZURE_SQL_CONNECTION_STRING="azure_sql_connection_string"
export AZURE_SQL_USERNAME="azure_sql_username"
export AZURE_SQL_PASSWORD="azure_sql_password"
```

Now, the Go test script:

```go
package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"testing"

	_ "github.com/denisenkom/go-mssqldb" // Import SQL Server driver
)

// TestSQLAlwaysOnMigration checks if the migration from on-premises SQL Always On DB to Azure SQL Always On DB is successful.
func TestSQLAlwaysOnMigration(t *testing.T) {
	// Set on-premises SQL Always On database connection details
	onPremConnectionString := os.Getenv("ON_PREM_SQL_CONNECTION_STRING")
	onPremUsername := os.Getenv("ON_PREM_SQL_USERNAME")
	onPremPassword := os.Getenv("ON_PREM_SQL_PASSWORD")

	// Connect to the on-premises SQL Always On database
	onPremDB, err := sql.Open("sqlserver", fmt.Sprintf("sqlserver://%s:%s@%s", onPremUsername, onPremPassword, onPremConnectionString))
	if err != nil {
		t.Fatalf("Error connecting to the on-premises SQL Always On database: %v", err)
	}
	defer onPremDB.Close()

	// Set Azure SQL Always On database connection details
	azureConnectionString := os.Getenv("AZURE_SQL_CONNECTION_STRING")
	azureUsername := os.Getenv("AZURE_SQL_USERNAME")
	azurePassword := os.Getenv("AZURE_SQL_PASSWORD")

	// Connect to the Azure SQL Always On database
	azureDB, err := sql.Open("sqlserver", fmt.Sprintf("sqlserver://%s:%s@%s", azureUsername, azurePassword, azureConnectionString))
	if err != nil {
		t.Fatalf("Error connecting to the Azure SQL Always On database: %v", err)
	}
	defer azureDB.Close()

	// Check if migration is successful
	if err := checkSQLAlwaysOnMigration(onPremDB, azureDB); err != nil {
		t.Errorf("SQL Always On database migration check failed: %v", err)
	}
}

func checkSQLAlwaysOnMigration(onPremDB, azureDB *sql.DB) error {
	// Add your logic here to check the success of migration for SQL Always On databases
	// You might want to compare database structures, data, or perform specific queries

	// Example: Check if a specific table exists in both databases
	if err := checkTableExists(onPremDB, "MIGRATION_TABLE"); err != nil {
		return fmt.Errorf("on-premises SQL Always On database migration check failed: %v", err)
	}

	if err := checkTableExists(azureDB, "MIGRATION_TABLE"); err != nil {
		return fmt.Errorf("Azure SQL Always On database migration check failed: %v", err)
	}

	// Compare database structures (you might want to compare schemas, tables, etc.)
	if err := compareDatabaseStructure(onPremDB, azureDB); err != nil {
		return fmt.Errorf("database structure comparison failed: %v", err)
	}

	return nil
}

func compareDatabaseStructure(onPremDB, azureDB *sql.DB) error {
	// Add your logic here to compare the structure of SQL Always On databases
	// You may want to compare schemas, tables, columns, data types, etc.

	// Example: Compare table names
	onPremTables, err := getTableNames(onPremDB)
	if err != nil {
		return fmt.Errorf("error getting on-premises table names: %v", err)
	}

	azureTables, err := getTableNames(azureDB)
	if err != nil {
		return fmt.Errorf("error getting Azure table names: %v", err)
	}

	// Compare table names
	if len(onPremTables) != len(azureTables) {
		return fmt.Errorf("number of tables is different: on-premises=%d, Azure=%d", len(onPremTables), len(azureTables))
	}

	// Compare table structures (columns, data types, constraints, etc.)
	for _, tableName := range onPremTables {
		if err := compareTableStructure(onPremDB, azureDB, tableName); err != nil {
			return fmt.Errorf("table structure comparison failed for table %s: %v", tableName, err)
		}
	}

	return nil
}

// Other functions (

getTableNames, compareTableStructure, etc.) remain the same as in the previous example.

func TestMain(m *testing.M) {
	// Set up any test fixtures or environment before running the tests
	// ...

	// Run the tests
	exitCode := m.Run()

	// Clean up or perform additional actions after tests are complete
	// ...

	os.Exit(exitCode)
}
```

In this script:

- The `TestSQLAlwaysOnMigration` function connects to both the on-premises SQL Always On database and the Azure SQL Always On database.
- The `checkSQLAlwaysOnMigration` function checks if a specific table exists in both databases and compares their structures.
- The `compareDatabaseStructure` function compares the structure of SQL Always On databases, including schemas, tables, columns, data types, etc.

Note: The exact comparison logic might vary based on your specific database schema and migration requirements. Adapt the queries and logic to match your SQL Always On setup and migration steps.



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

SQL Always On high-availability test

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


 Below is a simplified example of a Go test script (`sql_always_on_test.go`) for SQL Always On high-availability testing. This script uses the `testing` package in Go.

```go
package main

import (
	"database/sql"
	"fmt"
	"log"
	"testing"
	"time"

	_ "github.com/denisenkom/go-mssqldb" // Import SQL Server driver
)

// TestSQLAlwaysOnHighAvailability simulates failover scenarios and stress-tests SQL Always On clusters.
func TestSQLAlwaysOnHighAvailability(t *testing.T) {
	// Set SQL Always On connection details
	connectionString := "sqlserver://username:password@sql_always_on_server/database_name"

	// Connect to the SQL Always On cluster
	db, err := sql.Open("sqlserver", connectionString)
	if err != nil {
		t.Fatalf("Error connecting to SQL Always On cluster: %v", err)
	}
	defer db.Close()

	// Perform failover simulation
	if err := simulateFailover(db); err != nil {
		t.Errorf("Failover simulation failed: %v", err)
	}

	// Perform stress testing
	if err := stressTestCluster(db); err != nil {
		t.Errorf("Cluster stress test failed: %v", err)
	}
}

// simulateFailover simulates a failover scenario in the SQL Always On cluster.
func simulateFailover(db *sql.DB) error {
	// Execute SQL queries to initiate a failover
	_, err := db.Exec("ALTER DATABASE [YourDatabase] SET FAILOVER")
	if err != nil {
		return fmt.Errorf("failover simulation failed: %v", err)
	}

	// Add additional checks or queries to ensure failover completion

	return nil
}

// stressTestCluster performs stress testing on the SQL Always On cluster.
func stressTestCluster(db *sql.DB) error {
	// Execute stress tests (e.g., high-volume queries, transactions, etc.)
	// ...

	return nil
}

func TestMain(m *testing.M) {
	// Set up any test fixtures or environment before running the tests
	// ...

	// Run the tests
	exitCode := m.Run()

	// Clean up or perform additional actions after tests are complete
	// ...

	// Wait for a moment to allow any asynchronous operations to complete
	time.Sleep(2 * time.Second)

	// Exit with the code from the tests
	log.Printf("Tests exited with code %d", exitCode)
}

```

In this script:

- The `TestSQLAlwaysOnHighAvailability` function tests failover simulation and stress testing for the SQL Always On cluster.
- The `simulateFailover` function simulates a failover scenario using an SQL query. You may need to adjust this based on your SQL Server setup.
- The `stressTestCluster` function can be expanded to include various stress tests on the SQL Always On cluster.

Please replace `"username"`, `"password"`, `"sql_always_on_server"`, and `"database_name"` with your actual SQL Server connection details.

Remember to adapt the stress tests based on your specific requirements and the characteristics of your SQL Always On cluster.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
