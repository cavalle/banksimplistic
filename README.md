# BankSimplistic #

BankSimplistic is a sandbox for exploring concepts like Command-Query Responsibility Segregation (CQRS), Event Sourcing and Domain-Driven Design (DDD) with Ruby.

It's unashamedly based on Mark Nijhof's [Fohjin](http://github.com/MarkNijhof/Fohjin) from which it borrows the domain model of the sample application as well as the main elements of its architecture. However, while Fohjin is a Windows app written in C#, BankSimplisting is a Rails web app coded using idiomatic Ruby.

![Bank](http://dl.dropbox.com/u/645329/bank.jpg)

## Getting started ##

BankSimplistic is a Rails 2.3.8 application developed on Ruby 1.8.7. Its gem dependencies are specified in the `environment.rb` file so they can be installed by just running:

    $ rake gems:install
  
For persistence the app uses [Redis](http://code.google.com/p/redis/). So a Redis server is expected to be installed and running on the standard port. This can be done easily in MacOSX like this:

    $ brew install redis
    $ redis-server
  
With all that set, the test suite should pass by just running:

    $ rake
  
## Directory Structure ##

There are some differences in the directory structure comparing to a standard Rails app that are worth noting.

**app/models**

ActiveRecord is not used, so it's disabled in `environment.rb` and the `models` directory is removed.

**app/controllers**

Traditional `ActiveController` controllers are used here. The interesting part is the segregation of queries and commands. `index` and `show` actions only query the reporting repository, while `create`, `update` and `delete` actions exclusively execute commands.

**app/command_handlers**

Commands executed from controller actions are handled by the classes in this directory. This additional layer abstracts controllers from the domain model which is never exposed to any presentation layer. The responsibility of a Command Handler is finding the proper Aggregate Root and pass the request along.

The `CommandBus` module, included in `ApplicationController`, takes care of looking up the proper handler for the requested command.

**app/domain**

This is the equivalent to the missing `app/models` and you'll find the entities and aggregate roots of the domain. As you'd expect, all the domain logic is here. The interesting thing is the use of the _Event Sourcing_ pattern.

`AggregateRoot` and `DomainRepository` modules take care of persisting and publishing events as well as restoring domain objects from them. Only events are persisted in the current implementation (no _Memento_ pattern) and we use Redis for that.

**app/reporting**

Reports are subscribed to events from the domain model and update themselves according to those events. That way they are always in sync but totally uncoupled from the domain model. The reporting repository is denormalized and persisted with Redis.

**app/infrastructure**

Typically the contents of this directory would be inside `lib` (or a plugin or gem) but, for development purposes, it turned out more convenient to put them in directory added to the `load_path`

**spec/acceptance**

A suite of end-to-end acceptance specs is useful to make sure everything works as expected during the continuous evolution and refactoring of the architecture of the app. A nice pattern that seems to emerge here is that each user story corresponds with a command/event the system is supposed to handle. 

We use Capybara to interact with the app but for setting the context, instead of the usual fixtures or factories, we can  invoke commands.

No unit specs, everything's way too unstable yet.

## Resources ##

**[CQRS a la Greg Young](http://cre8ivethought.com/blog/2009/11/12/cqrs--la-greg-young/)**

This post, along with a series of posts linked from the [Fohjin's Readme](http://github.com/MarkNijhof/Fohjin#readme), elaborates on the architecture and patterns used in the Fohjin sample app, most of which are also implemented in BankSimplistic.

**[Domain-Driven Design by Eric Evans](http://books.google.com/books?id=7dlaMs0SECsC)**

For basic concepts like _aggregates_, _aggregate roots_, _entities_, etc. you can find several resources around the web, although the canonical one is the original DDD book by Eric Evans. This is gold.

**[Why use event sourcing](http://codebetter.com/blogs/gregyoung/archive/2010/02/20/why-use-event-sourcing.aspx)**

Greg Young is one of the main promotors of Event Sourcing. In this post he explains his particular vision of the pattern and the motivations and benefits of using it.

**[Event Sourcing](http://martinfowler.com/eaaDev/EventSourcing.html)**

Fowler's offers here a more comprehensive description of the pattern, including not also its benefits but also some drawbacks.

**[Hexagonal architecture](http://alistair.cockburn.us/Hexagonal+architecture)**

Alistair Cockburn's article about another pattern which relates conceptually to the ones we're going into here.

## Let's explore together ##

If you're interested in exploring further the ideas and patterns behind BankSimplistic feel free to contact me, open issues in the tracker, add comments to the code or fork the project and share your own experiments (there are lot of things to try by just looking at the original Fohjin). 

-- Luismi Cavallé
