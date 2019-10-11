# Github Workflow

This document describes our Github workflow.

## Creating issues

1. Decide if issue is bug related, a feature request or something else. Pick the appropriate template.
2. Fill in the relevant sections of the template.
3. (Optional) Assign it to someone.
4. Add the appropriate labels. Bug reports already have the `bug` label, but more might be appropriate.
5. Add it to the `Samfundet` project.
6. (Optional) Add it to a milestone if it's part of some greater goal.

## Doing the Lord's Good Work

1. Choose an issue.
2. Assign youself to the issue so that everybody knows who does what.
3. Branch out from `master`. Give the branch a descriptive name. Use dashes (`-`) between words.
4. Do the lord's good work.
5. When finished, consider rebasing – It's nice, but not critical. Push your branch to our repository.
6. When Travis is happy, make a pull request. In the description of the pull request, reference the issue you're working on. For example, you can write `Fixes #xxx` where `xxx` is the number of the issue you're working on. For more information about Github issue/PR keyworrds, check out [this](https://help.github.com/en/articles/closing-issues-using-keywords) article. You'll get auto-completion when writing `#` before entering the number. When adding that to the description, it will automatically close the issue when the pull request is merged into our default branch, which is `master`.
7. Every PR needs at least one accepted review. This is to make sure that everything that gets deployed is looked at by at least two pairs of eyes. Assign someone who's available.
8. Merge your PR into `master`.
9. When appropriate, this will be deployed; ideally first to our beta site, and then to prorduction.

