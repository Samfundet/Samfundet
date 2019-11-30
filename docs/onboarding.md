# Onboarding

## Introduction

Samfundet is a large projet, and it will take time to grasp everything. But fear not, there are several things that work in our favour:

- Ruby on Rails (RoR, Rails) preaches the "convention over convenience", which means that Rails usually dictates where files you create end up, what different things should be named, and so forth. There are pros and cons to this, thought.
- We're standing on the shoulders of giants. Some hard-working people created Samfundet for many years ago, and this is the (checks notes) fourth edition. Since this is both an old *and* a large project, many things have already been done. If you're going to create some new functionality, like creating a new view and showing some data, it has already been done, so the easiest way to get started is looking up existing code and working from there.

Creating a good onboarding experience for new members of MG::Web is difficult, as documentation with too much detail will quickly get old. At the same time, too little detail will not be informative. So this is an attempt at trying to capture that golden middle road.

## Technologies and patterns

We'll start with the different technologies we're using. That will give an overview of the highest level. Good resources to the different technologies are also included.

- **Ruby**: The programming language we're using. If you know Python, you'll be fine.
  - [Ruby Documentation Overview](https://www.ruby-lang.org/en/documentation/): The documentation overview that Ruby provides, with links to a number of resources, like the [Ruby Wikibook](https://en.wikibooks.org/wiki/Ruby_Programming).
  - [Learn Ruby in Y Minutes](https://learnxinyminutes.com/docs/ruby/): A very convenient resource for getting a no-bullshit overview of the Ruby language. Probably works best if you're good in another programming language and just needs to know how things are done in Ruby.
- **Ruby on Rails**: [Ruby on Rails](https://rubyonrails.org/) (RoR) is a way for creating web applications. It uses the Ruby programming language (obviously). It can feel kind of magic a times, but you'll get used to it and it'll be beautiful.
  - [The Rails Book](https://www.learnenough.com/ruby-on-rails-4th-edition-tutorial/beginning): The classical appoach for learning RoR in MG::Web. The book has now gone payment wall, but the old version 5 book is still up and rockin'. As of November 2019 we're planning on purchasing all of the books in he Learn Enough series, including the Rails book.
  - [RailsGuides](https://guides.rubyonrails.org/v5.2/): There are a *lot* of resources on this site for all important aspects of RoR. These are maybe not the first tutorials you'll look at, but when you want to dive deeper, definitely check out these.
- **MVC**: MVC stands for **M**odel-**V**iew-**C**ontroller and is a way to structure coding projects, for instance web applications like Samfundet.
  - **Model**: There are many different models in this project. We have an `event` model that contains information about when an event starts, what type of tickets you can purchase, the age limit, the location, et cetera.
  - **View**: The view is what we're showing to the users. We have views for showing data about either a speicfic or many different events. The latter is for instance the front page where you see the upcoming events at Samfundet.
  - **Controller**: The controller is the glue between the model and the view. In the controller you'll have code that fetches some events from the database and passes them on to the view so that the view can display it.
- **PostgreSQL**: The database we're using. You'll mainly interact with this though Ruby on Rails, but you'll still need to know the terminology and concepts.
  - [Introductory Tutoial](http://www.postgresqltutorial.com/): A basic tutorial for PostgreSQL for getting you up to speed on it.
- **HAML**: Ruby on Rails uses the ERB template language by default, which is a way of combining traditional HTML with Ruby code. HTML is a tad easier on the eyes, but still quite similar to traditional HTML. It also helps knowing how ERB works.
  - [HAML tutorial](http://haml.info/tutorial.html): The introductory tutorial by the creators themselves.
  - [HAML reference](http://haml.info/docs/yardoc/file.REFERENCE.html): Not really a tutorial, but yeah, a reference.

## Structure

Samfundet is big and often times messy, and as a result it can be hard to find you way around it. Let's go though the various interesting locations you'll often work in.

- `app`: This is the folder containing almost all code you'll touch in this project. The section about technologies and patterns mentions the MVC pattern, and all your models, views and controllers can be found here, as well as lots of other things.
  - `abilities`: All users at `samfundet.no` have a role with a set of permissions. MG::Web must be able to do everything, so they have all permissions. This means they can see *everything*. Other people only have the permissions they actually need. These things are specificed in the files in this directory. For more information on the permissions system, check out the documentation on [Cancancan](cancancan.md) and the [role system](role_system.md).
  - `assets`: The assets directory primarily contains Javascript, CSS and images.
  - `controllers`: Contains all controllers used in the project.
  - `helpers`: Every controller has a corresponding helper file that can contain relevant functionality for that controller. They are put here.
  - `models`: All models. `event.rb` and many others can be found here. Check them out!
  - `views`: All views are put here.

That was the top-most, kind of generic introduction to the sructure of the project. This does not really provide too much information, so we'll dig a little deeper. The following subsections will provide some essential details to help you get started.

### Views and assets

#### Templates

Views in Rails are based on the idea that you have a base HTML file and "child" HTML files that are put directly ino the base file. The base file can be found at `app/views/layouts/application.html.haml`. There you'll see the familiar `html`, `header`, `body` and `footer` tags, a long with many others.

As mentioned in the previous paragraph, you have kind of "child" HTML files that are put into this file. I have copied a small portion of the `application.html.haml` file and pasted in here and marked where child views are inserted.

```erb
%body{ class: ('dev-filter' unless Rails.env.production?) }
    (... not important stuff ...)

        #content{ class: "#{params[:controller]} #{controller.action_name}" }
          != display_flash
          - if Rails.application.config.billig_offline
            .billig-offline
              - if I18n.locale == :no
                = Rails.application.config.billig_message_no
              - else
                = Rails.application.config.billig_message_en
          = yield <--- here!

      #sticky-footer-wrapper-footer
```

The `yield` section will be replaced with the actual view that is being presented. For instance, when the user goes to `samfundet.no`, she will then make the HAML code at `app/views/site/index.html.haml` be inserted where `yield` is located. This particular HAML file is chosen because the `SiteController` is chosen as the root controller, and `index` is what is displayed by default.

#### CSS and JS

If you're then wondering how these views are styled and scripted, remember there is an `assets` directory containing all stylesheets in the project. The `app/views` directory has the same directory structurre as `app/assets/stylesheets` and `app/assets/javascripts`, namely something like this:

- applicants
- documents
- events

This means that if you define a Javascript function in `app/assets/javascript/applicants` like so

```javascript
$(function() {
    $("#show_reserved").click(function (event) {
        $(".reserved").toggleClass('display-reserved');
    });
});
```

then this can be used in HAML like so

```erb
%input#show_reserved{type:"checkbox", checked: true}
```

In the same way a class styling defined in `app/assets/stylesheets/applicants/_form.scss` like this

```scss
.gdpr_checkbox {
  margin-left: 25.5%;
    label {
      text-align: left !important;
      text-transform: none !important;
      width: 100% !important;
      margin-left: 10px;
    }
    input {
      width: 1em !important;
      margin: 0.16em 0.5em 0 0 !important;
      font-weight: 300 !important;
    }
}
```

can be referenced in `app/views/applicants/_form.html.haml` like this

```erb
.gdpr_checkbox
      != form.input :gdpr_checkbox, (...)
```

Because of the hierarchy in the `app` directory, Rails knows where it should look for files, functions, et cetera, which glues everything together. Roughly.

#### Localization (translation)

If you're working with text that is to be presented to the user, most likely it should be translated. To find existing translations for a view, look in the `config/locales/views` directory (not inside the `app` directory). Here you'll see a similar structure as for `app/assets/stylesheets` and the others.

Since we've been looking in the `applicants` directory for stylesheets, scripts and views, let's do this again for translations. Inside the `config/locales/views/applicants` directory there are two files, `en.yml` and `no.yml`. We only support Norwegian and English, so these files correspond to these two languages.

Generally, when you translate some text in a view (or other places as well), you'll want to use the `t()` function that translates, or the corresponding `T()` function that also capitalizes the letters. It looks like this:

```erb
t('applicants.interested_other_positions_hint')
```

Based on the language set on the site, it will either use the English or Norwegian version file. The English language file looks like this:

```yaml
en:
  applicants:
    (... other translations ...)
    interested_other_positions_hint: "Are you interested in offers for other positions beyond the ones you will apply to?"
```

The Norwegian looks similar:

```yaml
'no':
  applicants:
  	(... other translations ...)
    interested_other_positions_hint: "Er du interessert i å få tilbud om andre stillinger enn de du søker på?"
```

Every `.`(dot) in `t('applicants.interested_other_positions_hint')` specifies an indented level.