This is a little Sinatra app notifies Hipchat of any changes in the build status on your CruiseControl.rb install.

Heroku-ready! Just follow these steps:

1. Grab a copy of the source

        git clone git@github.com:andrewpbrett/cruisecontrolrb-to-hipchat.git

2. Create a Heroku app

        heroku create myapp

3. Required configuration
				
				heroku config:add HIPCHAT_AUTH_TOKEN=your_auth_token
				heroku config:add HIPCHAT_ROOM_ID=your_room_id
				heroku config:add CC_URL=your_cruise_control_url

4. Optional configuration:

				Basic auth for your CruiseControlrb install (recommended):
				
				heroku config:add CC_USERNAME=your_username
				heroku config:add CC_PASSWORD=your_password
				
				heroku config:add POLLING_INTERVAL							 # polling interval in minutes. defaults to 1 minute.
				heroku config:add HIPCHAT_FROM=cruise-control    # who the messages are "from" in hipchat. defaults to 'cruise-control'		

5. Deploy to Heroku

        git push heroku master

6. Have a beer while you wait for your first notification in Hipchat.

7. NOTE: for best results, install the New Relic add-on to your Heroku project to [prevent it from idling](http://stackoverflow.com/questions/5480337/easy-way-to-prevent-heroku-idling).