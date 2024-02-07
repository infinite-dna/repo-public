Checking the size of an Oracle database and verifying that all tables are identical between the on-premises and Azure databases involves more advanced logic. Below is an extended example of a Go test script (`oracle_migration_test.go`) that includes functions to check the database size and compare all tables' structure.

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
