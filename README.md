# SonarQube Badges

Use badges from a SonarQube server in a private network and a private GitHub repository.

This action provides the following functionality for GitHub Actions users:
- Download SonarQube badges through the SonarQube web API.
- Generate [shields.io](https://shields.io/badges) style badges.
- Save badge SVG images to a specific directory like `.badges`.
- Commit and push badge SVG images to the current branch.

## Badge Preview
### sonarqube badges
[![coverage.sonarqube](.badges/coverage.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![alert_status.sonarqube](.badges/alert_status.sonarqube.svg)](http://localhost:9000/dashboard?id=sample_sonar_projectKey)
[![bugs.sonarqube](.badges/bugs.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=bugs)
[![code_smells.sonarqube](.badges/code_smells.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=code_smells)
[![duplicated_lines_density.sonarqube](.badges/duplicated_lines_density.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=duplicated_lines_density)
[![ncloc.sonarqube](.badges/ncloc.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=ncloc)
[![reliability_rating.sonarqube](.badges/reliability_rating.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=reliability_rating)
[![security_hotspots.sonarqube](.badges/security_hotspots.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=security_hotspots)
[![security_rating.sonarqube](.badges/security_rating.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=security_rating)
[![sqale_index.sonarqube](.badges/sqale_index.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=sqale_index)
[![sqale_rating.sonarqube](.badges/sqale_rating.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=sqale_rating)
[![vulnerabilities.sonarqube](.badges/vulnerabilities.sonarqube.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=vulnerabilities)

### shields.io style badges
[![coverage.svg](.badges/coverage.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![alert_status.svg](.badges/alert_status.svg)](http://localhost:9000/dashboard?id=sample_sonar_projectKey)
[![bugs.svg](.badges/bugs.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=bugs)
[![code_smells.svg](.badges/code_smells.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=code_smells)
[![duplicated_lines_density.svg](.badges/duplicated_lines_density.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=duplicated_lines_density)
[![ncloc.svg](.badges/ncloc.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=ncloc)
[![reliability_rating.svg](.badges/reliability_rating.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=reliability_rating)
[![security_hotspots.svg](.badges/security_hotspots.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=security_hotspots)
[![security_rating.svg](.badges/security_rating.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=security_rating)
[![sqale_index.svg](.badges/sqale_index.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=sqale_index)
[![sqale_rating.svg](.badges/sqale_rating.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=sqale_rating)
[![vulnerabilities.svg](.badges/vulnerabilities.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=vulnerabilities)

#### coverage colors
[![coverage.100.svg](.badges/coverage.100.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.90.svg](.badges/coverage.90.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.80.svg](.badges/coverage.80.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.70.svg](.badges/coverage.70.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.60.svg](.badges/coverage.60.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.50.svg](.badges/coverage.50.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.40.svg](.badges/coverage.40.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.30.svg](.badges/coverage.30.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.20.svg](.badges/coverage.20.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.10.svg](.badges/coverage.10.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![coverage.0.svg](.badges/coverage.0.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)

## Pre-requisites
1. [Creating your SonarQube project](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/overview/#creating-sq-project)
1. [Integrating SonarQube analysis into your CI or build pipeline](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/overview/#integrating-into-ci-or-build)
1. [Adjusting the analysis of your project](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/overview/#adjusting-analysis)
1. [Setting the Server URL and the token in GitHub secrets](https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/github-integration/adding-analysis-to-github-actions-workflow/#setting-the-server-url-and-the-token-in-github-secrets)

## Requirements
- [Configuring your project](https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/sonarscanner/#configuring-your-project)
Create a configuration file in your project's root directory called `sonar-project.properties`.
```properties
sonar.projectKey=my-project
```

`soanr-badge` action will read your `sonar-project.properties` file and gather the following information from it:
- `sonar.projectKey` if provided
- `sonar.host.url` if provided
- `sonar.token` if provided

Or provide information via environment variables:
- `SONAR_PROJECT`: Project key. This is required if you don't have `sonar.projectKey` in your `sonar-project.properties` file.
- `SONAR_HOST_URL`: SonarQube server URL.
- `SONAR_TOKEN`: User token. It will get the project badge token via the `api/project_badges/token` API.
- `SONAR_PROJECT_BADGE_TOKEN`: Project badge token. This is required if you don't provide `SONAR_TOKEN` or if your SonarQube server doesn't provide permission for the `api/project_badges/token` API.

## Usage
```properties
sonar.projectKey=<replace with the key generated when setting up the project on SonarQube>
sonar.host.url=<replace host URL>
sonar.token=<replace with your user token>
```

The workflow YAML file will usually look something like this:

```yaml
- name: badge action
  uses: jadewon/sonar-badge@v1
  id: badge
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
    SONAR_PROJECT: project_key
```

If you already have a `sonar-project.properties` file that includes `projectKey` and `host.url`:
```properties
sonar.projectKey=<replace with the key generated when setting up the project on SonarQube>
sonar.host.url=<SonarQube server URL>
```

```yaml
permissions:
  contents: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: badge action
        uses: jadewon/sonar-badge@v1
        id: badge
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```
If you want to use SonarQube-provided badges:
```yaml
permissions:
  contents: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: badge action
        uses: jadewon/sonar-badge@v1
        id: badge
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          svgFrom: sonarqube
```
If you want specific metrics of badges only:
```yaml
permissions:
  contents: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: badge action
        uses: jadewon/sonar-badge@v1
        id: badge
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          metrics: coverage,alert_status
```
If you use another directory name to manage badges:
```yaml
permissions:
  contents: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: badge action
        uses: jadewon/sonar-badge@v1
        id: badge
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          directory: .sonar-badges
```

### Environments


| **Parameter**        | **Description**                                   | **Required?** | **Possible values**                                                           |
|-|-|-|-|
| **`GITHUB_TOKEN`** | Must set the contents permissions to `write` to push newly generated badges | required | `${{ secrets.GITHUB_TOKEN }}`
| **`SONAR_TOKEN`** | User token | optional | `${{ secrets.SONAR_TOKEN }}`
| **`SONAR_PROJECT_BADGE_TOKEN`** | Project Badge Token<br>You can find by opening the **Project Information** menu > **Get project badges** | optional | `${{ secrets.SONAR_TOKEN }}`
| **`SONAR_HOST_URL`** | The URL to your SonarQube Server. | optional | `${{ secrets.SONAR_HOST_URL }}`
| **`SONAR_PROJECT`** | The project's unique key. Can include up to 400 characters. All letters, digits, dash, underscore, periods, and colons are accepted. | optional | `project_key`

> [!NOTE]
> If you don't have permissions to get a user token, find the **Project Badge Token** to use it instead.

### Inputs

These are some of the supported input parameters of action.

| **Parameter**        | **Description**                                   | **Required?** | **Default** | **Note**                                                                                      |
|----------------------|---------------------------------------------------|---------------|-------------|-----------------------------------------------------------------------------------------------|
| **`directory`** | Directory where badges will be generated | optional | .badges | - |
| **`metrics`** | Target metrics to be generated, comma-separated | optional | all | **Possible values**<br>bugs<br>code_smells<br>coverage<br>duplicated_lines_density<br>ncloc<br>sqale_rating<br>alert_status<br>reliability_rating<br>security_hotspots<br>security_rating<br>sqale_index<br>vulnerabilities |
| **`svgFrom`** | Source of SVG badge images | optional | shields.io | - |

### Outputs

The following outputs are available from this GitHub Action:

- **list**: A list of generated badges.
- **markdown**: Markdown formatted badges.

##### outputs.list
```
.badges/alert_status.svg
.badges/bugs.svg
.badges/code_smells.svg
.badges/coverage.svg
.badges/duplicated_lines_density.svg
.badges/ncloc.svg
.badges/reliability_rating.svg
.badges/security_hotspots.svg
.badges/security_rating.svg
.badges/sqale_index.svg
.badges/sqale_rating.svg
.badges/vulnerabilities.svg
```

##### outputs.markdown
```markdown
[![quality gate](.badges/alert_status.svg)](http://localhost:9000/dashboard?id=sample_sonar_projectKey)
[![bugs](.badges/bugs.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=bugs)
[![code smells](.badges/code_smells.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=code_smells)
[![coverage](.badges/coverage.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=coverage)
[![duplicated lines](.badges/duplicated_lines_density.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=duplicated_lines_density)
[![lines of code](.badges/ncloc.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=ncloc)
[![reliability](.badges/reliability_rating.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=reliability_rating)
[![security hotspots](.badges/security_hotspots.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=security_hotspots)
[![security](.badges/security_rating.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=security_rating)
[![technical debt](.badges/sqale_index.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=sqale_index)
[![maintainability](.badges/sqale_rating.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=sqale_rating)
[![vulnerabilities](.badges/vulnerabilities.svg)](http://localhost:9000/component_measures?id=sample_sonar_projectKey&metric=vulnerabilities)
```
