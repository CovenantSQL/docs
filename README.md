# CovenantSQL Docs
Documentation of CovenantSQL and related tools, build with [Docusaurus](https://github.com/facebook/Docusaurus).

## Docs update
### docs
Update markdown docs in `/docs` folder, and make sure every doc file has the header
structure as following:
```
---
id: $doc_id
title: $doc_title
---
```

### sidebar
Update sidebar from `website/sidebars.json`:
```
{
  "docs": {
    "Intro": [ // category name
      "intro" // doc_id
    ],
    ...
    "About": [
      "usecase",
      "qna"
    ]
  }
}
```

## Publish
### before publish
- install [`yarn`](https://yarnpkg.com/lang/en/docs/install/)
- install node module dependencies `cd website && yarn install`

### ship
- `chmod +x ./ship.sh`
- `./ship.sh -v $version -u $github_username`
