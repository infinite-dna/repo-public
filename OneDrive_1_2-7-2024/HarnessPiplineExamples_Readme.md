Author Stan Zvenigorodskiy Email: Stanislav.zvenigorodskiy@infinite.com

Short article on how to use Harness for  those new to the platform as well as Library of simple pipelines.

---

# Harness  A Quick Guide

Harness is a powerful DevOps platform designed to simplify and streamline the software delivery process. Whether you're a seasoned developer or just getting started in the world of DevOps, Harness provides a user-friendly environment to orchestrate and automate your release pipelines. Let's explore some fundamental steps to get you started.

## Step 1: Sign Up and Set Up Your Account

To begin your journey with Harness, sign up for an account on the Harness platform. Once registered, follow the onboarding process to set up your account. This typically involves linking your version control system (like GitHub or Bitbucket) and defining your deployment targets (such as AWS, Azure, or Kubernetes clusters).

## Step 2: Create Your First Application

In Harness, an "Application" is a logical grouping of your microservices or components. To create your first application, navigate to the Harness dashboard, and select "Applications." Click on the "Add Application" button, provide a name, and define the type of application you are working with.

## Step 3: Define a Service

A "Service" in Harness represents an individual microservice or component within your application. Within your application, go to "Services" and click on "Add Service." Specify details such as the service name, artifact source (where your application code is stored), and any required settings.

## Step 4: Build Your Workflow

A "Workflow" in Harness is the sequence of steps that make up your deployment pipeline. Create a new workflow within your service, and define the stages, such as deployment to development, testing, and production environments. Configure the necessary deployment strategies, like canary releases or blue-green deployments.

## Step 5: Connect Your Infrastructure

Harness supports a wide range of deployment targets, from cloud providers like AWS and Azure to container orchestration platforms like Kubernetes. Connect your infrastructure by adding "Infrastructure Definitions" in Harness, specifying the details of your target environment.

## Step 6: Implement Continuous Verification

Harness includes features for continuous verification, ensuring that your deployments meet quality and compliance standards. Set up verification steps in your workflow to include tests, approvals, and rollback conditions.

## Step 7: Run Your Deployment

With your application, services, workflow, and infrastructure set up, it's time to run your first deployment. Trigger the deployment manually or integrate with your version control system for automatic deployments upon code commits.

## Step 8: Monitor and Analyze

Harness provides robust monitoring and analytics features. Explore the deployment dashboard to track the progress of your deployments, review logs, and analyze performance metrics. Leverage insights to continuously improve your deployment processes.

Harness offers extensive documentation and community support, making it easy for beginners to learn and implement best practices. As you become more familiar with the platform, you can explore advanced features like secrets management, Helm charts, and integrations with additional tools in your DevOps toolchain.

Harness simplifies the complexities of DevOps, allowing users to focus on delivering high-quality software efficiently. By following these steps, you'll be well on your way to harnessing the power of Harness for your development and deployment needs.



 YAML pipeline examples for Harness, considering enterprise reusable patterns.
 These examples cover various scenarios such as multi-environment deployments, canary releases,
 parameterization, and more:



1. **Basic Deployment Pipeline:**
   - Description: A simple pipeline for deploying an application.
   ```yaml
   version: '1.0'
   pipelines:
     - name: BasicDeploymentPipeline
       stages:
         - name: Deploy
           tasks:
             - name: DeployApp
               type: DEPLOY
               target:
                 type: ECS_SERVICE
   ```

2. **Rollback Pipeline:**
   - Description: A pipeline for rolling back to a previous version.
   ```yaml
   version: '1.0'
   pipelines:
     - name: RollbackPipeline
       stages:
         - name: Rollback
           tasks:
             - name: RollbackApp
               type: ROLLBACK
               target:
                 type: KUBERNETES
   ```

3. **Canary Deployment Pipeline:**
   - Description: A pipeline for canary deployments to test a new version with a subset of users.
   ```yaml
   version: '1.0'
   pipelines:
     - name: CanaryDeploymentPipeline
       stages:
         - name: CanaryDeploy
           tasks:
             - name: DeployCanary
               type: DEPLOY
               target:
                 type: AWS_LAMBDA_FUNCTION
   ```

4. **Multi-Environment Pipeline:**
   - Description: A pipeline for deploying to different environments (dev, test, prod).
   ```yaml
   version: '1.0'
   pipelines:
     - name: MultiEnvPipeline
       stages:
         - name: DeployDev
           tasks:
             - name: DeployToDev
               type: DEPLOY
               target:
                 type: EC2_INSTANCE
         - name: DeployTest
           tasks:
             - name: DeployToTest
               type: DEPLOY
               target:
                 type: AZURE_WEB_APP
         - name: DeployProd
           tasks:
             - name: DeployToProd
               type: DEPLOY
               target:
                 type: GOOGLE_COMPUTE_ENGINE
   ```

5. **Parameterized Pipeline:**
   - Description: A pipeline with parameters for flexibility.
   ```yaml
   version: '1.0'
   pipelines:
     - name: ParamPipeline
       variables:
         - name: AppVersion
           default: '1.0.0'
       stages:
         - name: Deploy
           tasks:
             - name: DeployWithParams
               type: DEPLOY
               target:
                 type: DOCKER_CONTAINER
               inputs:
                 - version: '${AppVersion}'
   ```

6. **Security Scanning Pipeline:**
   - Description: A pipeline with security scanning steps.
   ```yaml
   version: '1.0'
   pipelines:
     - name: SecurityScanPipeline
       stages:
         - name: Scan
           tasks:
             - name: SecurityScan
               type: SECURITY_SCAN
               target:
                 type: CONTAINER_REGISTRY
   ```

7. **Database Migration Pipeline:**
   - Description: A pipeline for database migrations.
   ```yaml
   version: '1.0'
   pipelines:
     - name: DBMigrationPipeline
       stages:
         - name: MigrateDB
           tasks:
             - name: RunMigration
               type: SCRIPT
               scriptType: SQL
               target:
                 type: DATABASE_INSTANCE
   ```

8. **Artifact Promotion Pipeline:**
   - Description: A pipeline for promoting artifacts across environments.
   ```yaml
   version: '1.0'
   pipelines:
     - name: ArtifactPromotionPipeline
       stages:
         - name: Promote
           tasks:
             - name: PromoteArtifact
               type: PROMOTE
               target:
                 type: ARTIFACT_REPOSITORY
   ```

9. **Docker Image Build Pipeline:**
   - Description: A pipeline for building and pushing Docker images.
   ```yaml
   version: '1.0'
   pipelines:
     - name: DockerBuildPipeline
       stages:
         - name: BuildAndPush
           tasks:
             - name: BuildDockerImage
               type: BUILD
               target:
                 type: DOCKER_REGISTRY
             - name: PushDockerImage
               type: PUSH
               target:
                 type: DOCKER_REGISTRY
   ```

10. **Integration Test Pipeline:**
    - Description: A pipeline for running integration tests.
    ```yaml
    version: '1.0'
    pipelines:
      - name: IntegrationTestPipeline
        stages:
          - name: IntegrationTest
            tasks:
              - name: RunIntegrationTests
                type: TEST
                target:
                  type: TEST_ENVIRONMENT
    ```

11. **Environment Provisioning Pipeline:**
    - Description: A pipeline for provisioning infrastructure environments.
    ```yaml
    version: '1.0'
    pipelines:
      - name: EnvProvisionPipeline
        stages:
          - name: Provision
            tasks:
              - name: ProvisionEnv
                type: PROVISION
                target:
                  type: CLOUDFORMATION_TEMPLATE
    ```

12. **Release Management Pipeline:**
    - Description: A pipeline for managing the release process, including approvals.
    ```yaml
    version: '1.0'
    pipelines:
      - name: ReleaseManagementPipeline
        stages:
          - name: Release
            tasks:
              - name: ReleaseApp
                type: RELEASE
                target:
                  type: AWS_ECS_CLUSTER
            approvals:
              - name: QAApproval
                type: MANUAL
                approvers:
                  - qa_team@example.com
    ```

13. **Enterprise Reusable Library Pipeline:**
    - Description: A pipeline that leverages reusable libraries for common tasks.
    ```yaml
    version: '1.0'
    pipelines:
      - name: ReusableLibraryPipeline
        stages:
          - name: Deploy
            tasks:
              - name: DeployUsingLibrary
                type: LIBRARY_TASK
                library:
                  name: CommonTasksLibrary
                  version: '1.2.0'
    ```

These examples cover a range of scenarios, but feel free to customize them based on your specific needs, environment configurations, and Harness features. Adjustments might be needed based on the integrations and platforms you're working with in your enterprise.


@@@@@@@@@@@@@@@@@@@---AZURE--@@@@@@@@@@@@@@


Examples of YAML pipelines for Harness using Azure as the deployment target. These examples cover various scenarios such as multi-environment deployments, canary releases, parameterization, and more:

1. **Basic Deployment Pipeline:**
   - Description: A simple pipeline for deploying an application.
   ```yaml
   version: '1.0'
   pipelines:
     - name: BasicDeploymentPipeline
       stages:
         - name: Deploy
           tasks:
             - name: DeployApp
               type: DEPLOY
               target:
                 type: AZURE_WEB_APP
   ```

2. **Rollback Pipeline:**
   - Description: A pipeline for rolling back to a previous version.
   ```yaml
   version: '1.0'
   pipelines:
     - name: RollbackPipeline
       stages:
         - name: Rollback
           tasks:
             - name: RollbackApp
               type: ROLLBACK
               target:
                 type: AZURE_FUNCTION_APP
   ```

3. **Canary Deployment Pipeline:**
   - Description: A pipeline for canary deployments to test a new version with a subset of users.
   ```yaml
   version: '1.0'
   pipelines:
     - name: CanaryDeploymentPipeline
       stages:
         - name: CanaryDeploy
           tasks:
             - name: DeployCanary
               type: DEPLOY
               target:
                 type: AZURE_CONTAINER_INSTANCE
   ```

4. **Multi-Environment Pipeline:**
   - Description: A pipeline for deploying to different environments (dev, test, prod).
   ```yaml
   version: '1.0'
   pipelines:
     - name: MultiEnvPipeline
       stages:
         - name: DeployDev
           tasks:
             - name: DeployToDev
               type: DEPLOY
               target:
                 type: AZURE_APP_SERVICE
         - name: DeployTest
           tasks:
             - name: DeployToTest
               type: DEPLOY
               target:
                 type: AZURE_FUNCTION_APP
         - name: DeployProd
           tasks:
             - name: DeployToProd
               type: DEPLOY
               target:
                 type: AZURE_WEB_APP
   ```

5. **Parameterized Pipeline:**
   - Description: A pipeline with parameters for flexibility.
   ```yaml
   version: '1.0'
   pipelines:
     - name: ParamPipeline
       variables:
         - name: AppVersion
           default: '1.0.0'
       stages:
         - name: Deploy
           tasks:
             - name: DeployWithParams
               type: DEPLOY
               target:
                 type: AZURE_FUNCTION_APP
               inputs:
                 - version: '${AppVersion}'
   ```

6. **Security Scanning Pipeline:**
   - Description: A pipeline with security scanning steps.
   ```yaml
   version: '1.0'
   pipelines:
     - name: SecurityScanPipeline
       stages:
         - name: Scan
           tasks:
             - name: SecurityScan
               type: SECURITY_SCAN
               target:
                 type: AZURE_CONTAINER_REGISTRY
   ```

7. **Database Migration Pipeline:**
   - Description: A pipeline for database migrations.
   ```yaml
   version: '1.0'
   pipelines:
     - name: DBMigrationPipeline
       stages:
         - name: MigrateDB
           tasks:
             - name: RunMigration
               type: SCRIPT
               scriptType: SQL
               target:
                 type: AZURE_SQL_DATABASE
   ```

8. **Artifact Promotion Pipeline:**
   - Description: A pipeline for promoting artifacts across environments.
   ```yaml
   version: '1.0'
   pipelines:
     - name: ArtifactPromotionPipeline
       stages:
         - name: Promote
           tasks:
             - name: PromoteArtifact
               type: PROMOTE
               target:
                 type: AZURE_ARTIFACTS
   ```

9. **Docker Image Build Pipeline:**
   - Description: A pipeline for building and pushing Docker images.
   ```yaml
   version: '1.0'
   pipelines:
     - name: DockerBuildPipeline
       stages:
         - name: BuildAndPush
           tasks:
             - name: BuildDockerImage
               type: BUILD
               target:
                 type: AZURE_CONTAINER_REGISTRY
             - name: PushDockerImage
               type: PUSH
               target:
                 type: AZURE_CONTAINER_REGISTRY
   ```

10. **Integration Test Pipeline:**
    - Description: A pipeline for running integration tests.
    ```yaml
    version: '1.0'
    pipelines:
      - name: IntegrationTestPipeline
        stages:
          - name: IntegrationTest
            tasks:
              - name: RunIntegrationTests
                type: TEST
                target:
                  type: AZURE_FUNCTION_APP
    ```

11. **Environment Provisioning Pipeline:**
    - Description: A pipeline for provisioning infrastructure environments.
    ```yaml
    version: '1.0'
    pipelines:
      - name: EnvProvisionPipeline
        stages:
          - name: Provision
            tasks:
              - name: ProvisionEnv
                type: PROVISION
                target:
                  type: AZURE_RESOURCE_MANAGER_TEMPLATE
    ```

12. **Release Management Pipeline:**
    - Description: A pipeline for managing the release process, including approvals.
    ```yaml
    version: '1.0'
    pipelines:
      - name: ReleaseManagementPipeline
        stages:
          - name: Release
            tasks:
              - name: ReleaseApp
                type: RELEASE
                target:
                  type: AZURE_AKS_CLUSTER
            approvals:
              - name: QAApproval
                type: MANUAL
                approvers:
                  - qa_team@example.com
    ```

13. **Enterprise Reusable Library Pipeline:**
    - Description: A pipeline that leverages reusable libraries for common tasks.
    ```yaml
    version: '1.0'
    pipelines:
      - name: ReusableLibraryPipeline
        stages:
          - name: Deploy
            tasks:
              - name: DeployUsingLibrary
                type: LIBRARY_TASK
                library:
                  name: CommonTasksLibrary
                  version: '1.2.0'
    ```

These examples cover a range of scenarios, but feel free to customize them based on your specific needs, environment configurations, and Azure services. Adjustments might be needed based on the integrations and platforms you're working with in your enterprise.
