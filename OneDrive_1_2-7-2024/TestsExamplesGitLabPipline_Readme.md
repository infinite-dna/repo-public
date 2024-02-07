Author  Stan Zvenigorodskiy email: stanislav.zvenigorodskiy@infinite.com

GitLab CI/CD pipeline to check connectivity with various DevOps tools (Harness, Jenkins, Nexus, Ansible Tower) and ensuring GitLab Runner can reach other DevOps tools involves a series of steps. Below is an example .gitlab-ci.yml file that you can use as a starting point. Note that you'll need to adapt the URLs, tokens, and other parameters based on your specific setup.


```yaml
stages:
  - connectivity

variables:
  HARN_STANDALONE_API_URL: "https://harness.example.com/api/graphql"
  JENKINS_API_URL: "https://jenkins.example.com/api/json"
  NEXUS_API_URL: "https://nexus.example.com/service/rest/v1/status"
  ANSIBLE_TOWER_API_URL: "https://ansible-tower.example.com/api/v2/ping"
  JIRA_API_URL: "https://jira.example.com/rest/api/2/issue"
  SERVICENOW_API_URL: "https://your-servicenow-instance.service-now.com/api/now/table/change_request"

connectivity-check:
  stage: connectivity
  script:
    - apt-get update -qy
    - apt-get install -y curl jq

    # Check connectivity with Harness
    - echo "Checking connectivity with Harness..."
    - curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $HARN_API_TOKEN" -d '{"query": "{ version }"}' $HARN_STANDALONE_API_URL | jq .

    # Check connectivity with Jenkins
    - echo "Checking connectivity with Jenkins..."
    - curl -u $JENKINS_USERNAME:$JENKINS_TOKEN $JENKINS_API_URL

    # Check connectivity with Nexus
    - echo "Checking connectivity with Nexus..."
    - curl -u $NEXUS_USERNAME:$NEXUS_PASSWORD $NEXUS_API_URL

    # Check connectivity with Ansible Tower
    - echo "Checking connectivity with Ansible Tower..."
    - curl -u $ANSIBLE_TOWER_USERNAME:$ANSIBLE_TOWER_PASSWORD -k $ANSIBLE_TOWER_API_URL

    # Check if GitLab Runner can reach other DevOps tools (replace IPs/URLs accordingly)
    - echo "Checking if GitLab Runner can reach other DevOps tools..."
    - ping -c 5 harness.example.com
    - ping -c 5 jenkins.example.com
    - ping -c 5 nexus.example.com
    - ping -c 5 ansible-tower.example.com

    # Fetch data from a Jira ticket using its number (replace $JIRA_TICKET_NUMBER with the actual ticket number)
    - echo "Fetching data from Jira ticket..."
    - curl -u $JIRA_USERNAME:$JIRA_TOKEN $JIRA_API_URL/$JIRA_TICKET_NUMBER

    # Perform a ServiceNow API call (replace $SERVICENOW_CHANGE_REQUEST_ID with the actual change request ID)
    - echo "Checking ServiceNow change control permissions..."
    - curl -u $SERVICENOW_USERNAME:$SERVICENOW_PASSWORD -H "Content-Type: application/json" $SERVICENOW_API_URL/$SERVICENOW_CHANGE_REQUEST_ID
```

Explanation:

- The ServiceNow API endpoint used is `$SERVICENOW_API_URL/$SERVICENOW_CHANGE_REQUEST_ID`, where `$SERVICENOW_CHANGE_REQUEST_ID` is a placeholder for the actual change request ID.
- Replace `$SERVICENOW_USERNAME` and `$SERVICENOW_PASSWORD` with your ServiceNow username and password.
- Adjust the `$SERVICENOW_CHANGE_REQUEST_ID` variable with the actual change request ID you want to check.
- Ensure that the ServiceNow instance is accessible from the GitLab Runner machine.

Make sure to replace the placeholder values with your actual URLs, tokens, credentials, and ServiceNow change request ID. Additionally, consider securing sensitive information like tokens and passwords using GitLab CI/CD secret variables.
