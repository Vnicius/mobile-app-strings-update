# Github Action: Mobile App Strings Update

This action get the strings from one repository and create a pull request to the mobile app repository updating the strings resources.

# Inputs

## `app_path`

Root path of the app files.

## `app_branch`

Base branch of the mobile app repository.

## `app_strings_path`

Path with the original strings directories in the mobile app project.

## `pr_branch`

Name of the branch that will be created to recieve the changes.

## `pr_title`

Title of the pull request.

## `pr_body`

Body of the pull request.

## `pr_commit`

Message of the commit for the changes.

## `strings_path`

Path with the new strings directories.

## `strings_file_name`

Name of the strings files.

# Usage

```yalm
    - name: Get resources repo
        uses: actions/checkout@v2
        with:
          path: resources

    - name: Get App repo
        uses: actions/checkout@v2
        with:
          repository: owner/app-repo
          ref: dev
          path: my-app


    - name: Update iOS Translations
        uses: vnicius/mobile-app-strings-update@v0.1
        env:
            GITHUB_TOKEN: ${{ secrets.YOUR_PAT }} # For private repositories
        with:
          app_path: app
          app_branch: dev
          app_strings_path: my-app/app/main/res
          strings_path: "./resources/"
          strings_file_name: "strings.xml"
          pr_branch: strings_update
          pr_title: "Update strings"
          pr_body: "Update by automated action"
          pr_commit: "Add new strings"
```
