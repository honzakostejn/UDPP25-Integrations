# Integrations with Custom Connectors, Dataflows and Virtual Tables
Update Days: Power Platform | 2025-02-05
- Matej Samler
- Jan Kostejn

---
# Business wants us to build an application

---
# Business wants us to build an application
Why?!?

---
# Business wants us to build an application
Why?!?
1. Hypothesis
2. Experiment
3. Data
4. Conclusion

---
# Power Platform as low-code / no-code
- Create an application (or at least proof-of-concept) in a few minutes
- Deploy it to a downstream environment
- **Get data**
- Satisfy the business requirements

---
# User adoption
NO DATA => NO ADOPTION => NO DATA

---
# Migrating / integrating existing data
- Dataflows
- Custom connectors
- Virtual tables

---
# DEMO: Dataflows

---
# DEMO: Custom connectors

---
# DEMO: Virtual tables

---
# Comparison
| Features\Solution    | Dataflows                                                                           | Custom connectors                                           | Virtual tables                       |
|----------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------|--------------------------------------|
| Scheduled synch      | Yes                                                                                 | Yes - implemented through Cloud flows                       | N/A - no data are duplicated         |
| Near real-time synch | No                                                                                  | Yes - implemented through Cloud flows (API must support it) | Yes                                  |
| Write-back           | No                                                                                  | Yes - implemented through Cloud flows                       | ?                                    |
| Interfaces           | [Power Query connectors](https://learn.microsoft.com/en-us/power-query/connectors/) | OpenAPI 2.0 (Swagger)                                       | OData v4, Virtual Connectors, Custom |

---
# Resources
github.com/honzakostejn/UDPP25-Integrations