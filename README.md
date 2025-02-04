# Integrations with Custom Connectors, Dataflows and Virtual Tables
This is a lab for the **Integrations with Custom Connectors, Dataflows and Virtual Tables** session of the [Update Days: Power Platform](https://power.updatedays.cz) conference.

## How to run the lab
### Windows
Currently not supported, but with small effort, I can do a PowerShell version of the lab. Create an issue (or upvote the existing one, if you're interested in it).

### Linux / macOS
The whole lab can be easily executed inside a bash shell, if all the dependencies are installed.

The easiest way is to use the nix package manager together with `nix develop` command. If you don't have nix installed, here's the list of dependencies:
- curl
- dotnet
- azure-cli
- bicep

Run all scripts from the root of the project due to relative paths being used.

1. Clone the repository.
1. Install all the dependencies to run this lab. **Optionally, you can run `nix develop`** in the root of the repository - shell with all dependencies will be provisioned, VSCode will be launched automatically.
1. Make sure all the scripts are executable.
    ```bash
    chmod +x ./src/scripts/*.sh
    ```
1. Run the `./src/scripts/install-dotnet-tools.sh` script to install all the necessary dotnet tools.

You should be set up and ready to go. The first demo is about Dataflows.
1. Run the `./src/scripts/dataflows.sh` script to build & deploy the dataflows. Pass the environment name as a first argument.
1. Publish the Dataflow on the environment.
1. Create an unmanaged `_CONFIG` solution and add `udpp25_` connection references. Update them.
1. Trigger the `Trigger Dataflow Refresh` cloud flow.
1. Review data in the application.

The second demo is about Custom Connectors and is currently not part of this lab.

The third and final demo is about Virtual Tables.
1. Run the `./src/scripts/virtual-tables.sh` script to build & deploy the virtual tables. Pass the environment name as a first argument. It is expected and required that the Dataflows solution is already deployed.

## Slides
---
### Integrations with Custom Connectors, Dataflows and Virtual Tables
Update Days: Power Platform | 2025-05-02
- Matej Samler
- Jan Kostejn

---
### Let's build an application
Why?!?
1. Hypothesis
2. Experiment
3. Data
4. Conclusion

---
### Power Platform as low-code / no-code
- Create an application (or at least proof-of-concept) in a few minutes
- Deploy it to a downstream environment
- **Get data**
- Satisfy the business requirements

---
### User adoption
NO DATA => NO ADOPTION => NO DATA

---
### Migrating / integrating existing data
- Dataflows
- Custom connectors
- Virtual tables

---
### DEMO: Dataflows

---
### DEMO: Custom connectors

---
### DEMO: Virtual tables

---
### Comparison
| Features\Solution    | Dataflows                                                                           | Custom connectors                                           | Virtual tables                       |
|----------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------|--------------------------------------|
| Scheduled synch      | Yes                                                                                 | Yes - implemented through Cloud flows                       | N/A - no data are duplicated         |
| Near real-time synch | No                                                                                  | Yes - implemented through Cloud flows (API must support it) | Yes                                  |
| Write-back           | No                                                                                  | Yes - implemented through Cloud flows                       | ?                                    |
| Interfaces           | [Power Query connectors](https://learn.microsoft.com/en-us/power-query/connectors/) | OpenAPI 2.0 (Swagger)                                       | OData v4, Virtual Connectors, Custom |

---
### Resources

---
