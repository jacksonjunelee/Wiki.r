## Wiki

A wiki is an application that allows users to create and modify content collaboratively. In a wiki application, the history of a document and changes to it are an important part of what they are. Wikis can chart and connect content from a variety of sources, and the interaction of users working on them. The most popular example is Wikipedia ([sample page](http://en.wikipedia.org/wiki/Gorham%27s_Cave)) but Github also comes with a nice wiki ([sample page](https://github.com/Netflix/Hystrix/wiki)).</span>

---

### Minimum Viable Product

**Entities**:

- `document`
  - `title`
- `version`
  - `blurb`
  - `content`
- `author`
  - `first_name`
  - `last_name`
  - `username`

**User Stories**:

- As a user, I want to be able to create a wiki document, so I can contribute to
  the wiki
- As a user, I want to be able to specify an author when creating a wiki
  document by choosing a pre-existing one from a drop-down menu, so I am
  recognized
- As a user, I want to be able to edit (create a new version for) a wiki
  document, so I can correct others' work
- As a user, I want to be able to delete a wiki document, so I can remove all
  traces of an inappropriate document
- As a user, I want to be able to create an author, so I can add more people to
  the wiki's community
- As a user, I want to be able to view an author's page that lists the documents
  that they have created or edited, so I can find out about their contributions
  to the wiki
- As a user, I want to be able to edit an author's information, so I can update
  my information
- As a user, I want to be able to see a history of changes (list of versions)
  for a document, so I can appreciate its evolution
- As a user, I want to be able to see a single version of the document, so I can
  inspect a document's snapshot in time in detail

---

### Bonus

- **Additional Entities**
  - `comment`
- **Further User Stories**:
  - As a user, I want to be able to search for wikis by title (only exact
    matches need to be supported), so I can quickly find what I'm looking for
  - As a user, I want to be able to add comments to a wiki page on a "discuss"
    page used to discuss changes to a wiki document, so collaborators can talk
    debate about changes to a document
  - As a user, I want to be able to see on the front page all recent activity
    done to the wiki (creations/edits/deletions), so I can keep up with the
    wiki's current events easily
  - As a user, I want to be able to revert a wiki document to a previous
    revision, so I can undo bad changes to a document. This should not remove
    any version, but should merely create a new version that is identical to the
    one which the user wants to revert to
  - **Super Bonus** Allow the user to be able to see a visual "diff" between
    two different versions of a document in its edit history (this would be very
    hard to do without using an external library of some sort)
