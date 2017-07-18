# Implementation Notes (Stage 1)

## Architectural/Framework Choices

1. Mix Phoenix 1.3 umbrella application
2. Ecto will be used. But in Stage 1, access to a database will be commented out and replaced by hard-wired data. As a result, no database system needs to be installed.
3. The phoenix web application is named shipping_web.

## Generating, Building and Running the Elixir version

Make sure you have the following installed:
* elixir 1.4
* phoenix 1.3 rc 2 __NOTA BENE:__ As of, 2 Jul 2017, the application requires the master branch of Phoenix. See below, in the building steps, on how to incorporate this version of Phoenix in the mix instructions (mix.exs).

### Generating this project.
Skip these steps if you have retrieved the project from GitHub.
1. mix phx.new ddd_elixir_stage1 --umbrella --app shipping
2. cd ddd_elixir_stage1_umbrella
3. mix deps.clean phoenix
4. Edit the mix.exs file in apps/shipping_web. Change the phoenix dependency to the following:
~~~~
{:phoenix, github: "phoenixframework/phoenix", override: true},
~~~~
this will ensure that you are using the master branch of the Phoenix repository.

5. mix deps.get
6. cd apps/shipping_web
7. mix phx.gen.html Tracking Cargo cargoes tracking_id status --web Tracking
8. mix phx.gen.html Tracking HandlingEvent handling_events type voyage location tracking_id completion_time registration_time --web Tracking
9. Edit apps/shipping_web/lib/shipping_web/router.ex and add the following scope after the existing scope:
~~~~
scope "/tracking", Shipping.Web.Tracking, as: :tracking do
  pipe_through :browser

  resources "/cargoes", CargoController
  resources "/handling_events", HandlingEventController
end
~~~~

### Building this project
1. cd ddd_elixir_stage1_umbrella
2. mix deps.get
3. cd apps/shipping_web/assets
4. npm install

### Running the web application
1. cd ddd_elixir_stage1_umbrella
2. mix phx.server

### Using the web application
The application is configured to be run by users in two roles: Customers and Cargo Handlers. For an effective demonstration, open two browser windows, one for each type of user.

In the Customer's window enter: [localhost:4000](localhost:4000). Enter 'ABC123' as a tracking number. The response will be a history of the Handling Events for this particular cargo.

In the Handler's window enter: [localhost:4000/tracking/handling_events](localhost:4000/tracking/handling_events). A list of Handling Events will appear. At the bottom of the page, click on the New Handling Event link. Enter data for a new event making sure you use the same tracking number: 'ABC123' When this new event is submitted, it will appear in this page's list of events and appear in the Customer's list of events.

Cargoes and HandlingEvents are managed by Elixir Agents. They are saved in their respective agent's state and in a file cache. The files are loaded by default  when this application is started. The files are named "cargoes.json" and "handling_events.json", respectively,
and are in the topmost directory. Entries in these files can be deleted if you wish to start from scratch and they can be
added to with any text editor so long as the id values are unique. Note that the starting status for a new Cargo is "BOOKED".

* [localhost:4000/tracking/handling_events](localhost:4000/tracking/handling_events) will list all of the handling events stored in its agent's state.
* [localhost:4000/tracking/cargoes](localhost:4000/tracking/cargoes) will list all of the cargoes stored in its agent's state.
* Handling events can be edited via a web page.
* Deletion is not supported as of 6 July 2017

## Observations on the Java Implementation
1. WebAPI requests. The following requests were noted while monitoring the network activity of the Java implementation's web pages. We will not need to address all of them, initially. And, of course, we can change them.
    1. Tracking
        1. GET dddsample/track
        2. POST dddsample/track
        trackingId: ABC123
    2. Booking - List tracking Ids
        1. GET dddsample/admin/list
    3. Booking - Select tracking Id
        1. GET dddsample/admin/show?trackingId=ABC123
    4. Booking - Change Destination
        1. GET dddsample/admin/pickNewDestination?trackingId=ABC123
        2. POST dddsample/admin/changeDestination
        trackingId: ABC123
        unlocode: NLRTM
        3. GET dddsample/admin/selectItinerary?trackingId=ABC123
    5. Booking - Book New Cargo
        1. GET dddsample/admin/registration
        2. POST dddsample/admin/register
        originUnlocode: JNTKO
        destinationUnlocode: CNHGH
        arrivalDeadline: 15/06/2017
    6. Booking - Book New Cargo - Select and Assign Route
        1. GET dddsample/admin/selectItinerary?trackingId=E58FD969
        2. POST dddsample/admin/assignItinerary
        trackingId: E58FD969
        legs[0].voyageNumber:0301S
        legs[0].fromUnLocode:JNTKO
        legs[0].toUnLocode:USNYC
        legs[0].fromDate:2017-06-17 09:47
        legs[0].toDate:2017-06-18 02:47
        legs[1].voyageNumber:0100S
        legs[1].fromUnLocode:USNYC
        legs[1].toUnLocode:CNHGH
        legs[1].fromDate:2017-06-21 02:59
        legs[1].toDate:2017-06-22 04:51
