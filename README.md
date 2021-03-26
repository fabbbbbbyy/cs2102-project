# cs2102-project
A schema for CS2102's project.

# Docker

## Starting the server
1. Navigate into the server folder from the command line.
2. Run `docker-compose up`.

## Stopping the server
1. Send <b>CTRL+C</b> via the command line (while the server is running).
2. Run `docker-compose down`.

# PGAdmin

## Setup
1. Run the server as shown above.
2. Open PGAdmin and enter your master password (if applicable).
3. Right-click the <b>Servers drop-down</b> menu on the left and select <b>Create -> Server...</b>.
4. Under the General tab, type <b>cs2102-project</b> in the <b>Name</b> field.
5. Under the Connection tab, type <b>0</b> in the <b>Host name/address</b> field and <b>cs2102-project</b> in the <b>Maintenance database</b> and <b>Username</b> fields.
6. Click <b>Save</b> at the bottom-right corner of the pop-up box. The server should now appear as <b>cs2102-project</b> in the <b>Servers</b> drop-down menu on the left.
7. Double-click on the server and enter <b>cs2102-project</b> as the password.
8. To view the contents of a table, go to <b>cs2102-project -> Databases -> cs2102-project -> Schemas -> public -> Tables</b>, right-click on a table, and click on <b>View/Edit Data</b>.

