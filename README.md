# Notebooks for the workshop "Tracing Sustainable Urban River Space Transformations"

This repository contains the computational notebooks used in the workshop ["Tracing Sustainable Urban River Space Transformations"](https://www.lorentzcenter.nl/tracing-sustainable-urban-river-space-transformations.html) on 9 April at Lorentz Center @lambda.

GitHub repository: [CityRiverSpaces/lorentz-workshop](https://github.com/CityRiverSpaces/lorentz-workshop)

## Demo notebook

A rendered version of the **CRiSp demo notebook** is available at the URL: <https://cityriverspaces.github.io/lorentz-workshop/demo.html>

In order to run the notebook live:

1. Clone and access this repository. You can do it from RStudio:
   * From the "Project" menu (top right), select `Create Project` > `Version Control` > `Git`
   * Paste the following URL as `Repository URL`: <https://github.com/CityRiverSpaces/lorentz-workshop.git> and select the path where you want to create the project directory (you can leave the field `Project directory name` empy).
   * Click on `Create Project`
3. If you are working on the shared RStudio Server, all dependencies should already be installed, so you can move on to point 4.
4. If you are working on your local machine, we recommend to install dependencies in a local R environment, which can be created by typing in the R console:
    ```r
    # install.packages("renv")
    renv::init()
    renv::install()
    ```
    When prompted for input, type `1` (i.e. `Use only the DESCRIPTION file`).
5. Open the file `demo.qmd`. You can run cells individually with the play button or render the full notebook with the `Render` button (blue arrow symbol on top of the `demo.qmd` panel).

## Develop a custom use-case notebook

To develop and contribute a **CRiSp use case notebook**, follow these steps:

0. If you do not have a GitHub account, [sign up](https://github.com), then log in and [configure SSH authentication](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account);
1. Fork this repository by following [this link](https://github.com/CityRiverSpaces/lorentz-workshop/fork), then click on `Create fork`;
2. Clone and access the forked repository. See instructions at point 1. in the previous section, using the following `Repository URL`: `git@github.com:GITHUB_USER/lorentz-workshop.git` (replace `GITHUB_USER` with your actual username);
3. Make a copy of the file [usecase.qmd](usecase.qmd) and rename it to `usecase-TYPE-CASE.qmd` by replacing `TYPE` with `single` or `multiple`, and `CASE` with `CITY_NAME-RIVER_NAME` and `CITY_RIVER_SET_NAME`, respectively;
4. Work together in the group to fill in the template with the chosen use case; Use the `Render` button to generate the rendered notebook as a `.html` file.
5. Commit and push changes to your fork. Include the newly created `.qmd` and `.html` files, as well as the corresponding `XXX_files` folder. If you are working in RStudio, you can do this from the `Git` tab:
    * Add a tick under `Staged` for the files or folder that you want to commit;
    * Click on the `Commit` button;
    * Type in a commit message in the top right box, then hit `Commit`;
    * Click on `Push` to push the newly added content to your forked repository.
6. Open a Pull Request on the upstream workshop repository to submit your use case and share any issues you encountered while implementing it in the notebook.
