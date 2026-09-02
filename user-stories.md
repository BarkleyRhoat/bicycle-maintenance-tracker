# User Stories - Bicycle Maintenance Tracker

## Feature 1 - User Authentication

User story: As a user, I want to sign up, log in, and log out so that my bikes and maintenance records are private and secure.

### Feature 1 Acceptance Criteria

- I can create an account with my name, email, and password.
- I can log in with my email and password.
- I can log out from any page.
- I only see my own bikes and maintenance logs after logging in.
- I see clear error messages if my sign-up or login information is invalid.

## Feature 2 - Bike Management

User story: As a logged-in user, I want to manage my bikes so that I can add, view, update, and remove bicycles from my tracker.

### Feature 2 Acceptance Criteria

- I see a list of all my bikes.
- I can add a new bike by entering its name and brand.
- I can view a bike to see its details, components, and maintenance history.
- I can edit a bike's name or brand.
- I can delete a bike I no longer own.
- I see a helpful message when I do not have any bikes yet.

## Feature 3 - Component Management

User story: As a logged-in user, I want to manage bicycle components so that I can track parts like chains, tires, and brake pads.

### Feature 3 Acceptance Criteria

- I see a list of available components.
- I can add a new component by entering its name and type.
- I can view a component to see its details and which bikes use it.
- I can edit a component's name or type.
- I can delete a component that is no longer needed.
- I see a helpful message when no components exist.

## Feature 4 - Bike Components

User story: As a logged-in user, I want to attach components to my bikes so that I know which parts are installed on each bicycle.

### Feature 4 Acceptance Criteria

- I can add a component to one of my bikes.
- I can record when the component was installed and how many miles it has covered.
- I can view all components attached to a bike.
- I can remove a component from a bike without deleting the component itself.

## Feature 5 - Maintenance Logs

User story: As a logged-in user, I want to record maintenance work for a specific bike so that I can keep a service history.

### Feature 5 Acceptance Criteria

- I can add a maintenance log to a bike from the bike's detail page.
- I can enter a service date, description, and the bike's mileage at the time of service.
- I can view all maintenance logs for a bike in chronological order.
- I can edit or delete a maintenance log.
- I see a helpful message when a bike has no maintenance logs yet.

## Feature 6 - View Maintenance by Association

User story: As a logged-in user, I want to view maintenance records by bike or component so that I can track service history and part lifespan.

### Feature 6 Acceptance Criteria

- I can view all maintenance logs for a specific bike.
- I can view all maintenance logs that involve a specific component.
- Each log shows the bike, component, service date, and description.
- I see a helpful message when no maintenance logs match my selection.

## Feature 7 - Validation and Error Handling

User story: As a user, I want clear feedback when I make a mistake so that I can fix it and continue.

### Feature 7 Acceptance Criteria

- Invalid forms are not saved.
- I see a list of error messages explaining what went wrong.
- I can correct my input and submit the form again.
