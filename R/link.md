[Mermaid ERD](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)

```mermaid
erDiagram
  data_set ||--|{ patient : token_person_id
  data_set ||--|{ demographics : study_id
```