# Data Flow Diagram (DFD) Design Document

A brief description of DFD on [Wikipedia](https://en.wikipedia.org/wiki/Data_flow_diagram).
Much of the following is based on the book "Structured Analysis and
System Specification" by Tom DeMarco.

The elements of a DFD are:
1. Data Flow -  A dataflow is a pipeline through which
packets of information of known composition flow.
2. Process - a transformation of incoming data flow(s) into outgoing data flows(s).
3. Source and Sink - entities (people, systems, etc.) lying outside the context of the system.
4. File/Repository - this can be a file, a database entity, and, uniquely for Elxir, stateful processes.

Note that DFD also employs the concept of a context and context boundary.

The general guidelines for developing a DFD are to, first, identify all of the dataflows in the domain of interest.
The next step is to begin connecting the data flows to processes, sources and sinks, and
files/repositories.

## DataFlows
Below is a proposed list of dataflows organized by domain model. The domain models are derived from the Java sample implementation package names.
### Domain Model: Cargo
1. Cargo
2. Delivery
3. Handling Activity
4. Itinerary
5. Route Specification [Is this what the book calls a Delivery Specification?]

### Domain Model: Handling
1. Handling Event
    1. Load onto Carrier
    2. Unload from Carrier
    3. Receive Cargo
    4. Claim Cargo
    5. Clear Customs
2. Handling History

### Domain Model: Location
1. Location

### Domain Model: Voyage
1. Carrier Movement
2. Schedule
3. Voyage

## Processes
These processes were derived from the methods in the Java implementation's Service interfaces.
### Booking Service
1. Book New Cargo
2. Request Possible Routes for Cargo
3. Assign Cargo to Route
4. Change Destination

### Cargo Inspection Service
1. Inspect Cargo

### Handling Event Service
1. Register Handling Event

## Sources and Sinks
/todo/

## File/Repository
/todo/
