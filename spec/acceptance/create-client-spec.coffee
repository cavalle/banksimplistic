zombie = require 'zombie'
assert = require 'assert'
redis  = require 'redis'
vows   = require 'vows'

client = redis.createClient()
client.send_command('flushdb')
client.quit()

browser = new zombie.Browser
# browser.debug = true

vows.describe("Create client").addBatch(
  "I'm in the clients page.":
    topic: -> browser.visit "http://localhost:3001/clients", this.callback

    "I click the new client link.":
      topic: -> browser.clickLink "New client", this.callback

      "I fill and send the form.":
        topic: ->
          browser.fill('Name', 'Bernadette Peters').
                  fill('Street', '17th Broadway, NY').
                  fill('Postal code', '10002').
                  fill('City', 'New York City').
                  fill('Phone number', '212-123-4567').
                  pressButton "Create client!", this.callback

        "I should see the new client listed.": ->
          assert.match browser.html(), /Bernadette Peters/

        "I click to go to the client's page.":
          topic: -> browser.clickLink "Show", this.callback

          "I should see the client's info.": ->
            assert.match browser.html(), /Bernadette Peters/
            assert.match browser.html(), /17th Broadway, NY/
            assert.match browser.html(), /10002/
            assert.match browser.html(), /New York City/
            assert.match browser.html(), /212-123-4567/
).run()
