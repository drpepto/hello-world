'use strict';

// Notice the ['$scope', 'HelloService', function ($scope, $helloService
// This is Angular's way of doing spring like dependency injection.
// When you add a <script line to the index.html loading that script
// registers the components. Now you can access them via name (on the
// left) and then assign them to variables (on the right)
angular.module('appApp')
  .controller('MainCtrl', ['$scope', 'HelloService', function ($scope, $helloService) {

      $scope.hello_list = [
	  {"id": 1, "name": "Tungjatjeta"}, 
	  {"id": 2, "name": "Grüßgott"}, 
	  {"id": 3, "name": "Вiтаю"}, 
	  {"id": 4, "name": "Piss Off!"}
      ];

      // A default value for say
      $scope.say = {};

      // Ajax is asynchronous. The only way to assign data to things
      // in this namespace is via call back methods you pass
      // around. Changes in scope will hurt your brain so try not to
      // get too fancy.

      // If the ajax call is successful, data will contain the json
      // payload. Assign it to a scope variable so Angular can bind to
      // it
      var say_callback = function(data) {
	  // AngularJS does auto magic binding on anything assigned to
	  // $scope. So now when we do {{said}} in the html templates,
	  // it will bind to this list
	  $scope.said = data;
	  $scope.errors = "";
      }

      // Warn the user the load failed
      var say_callback_fail = function(data) {
	  // Similar data binding except instead of a list as above,
	  // now we have a plain string
	  $scope.errors = "Failed to load said list"
      }

      // Dial the service to load the data from the api
      $helloService.all_said(say_callback, say_callback_fail);


      // This function will be triggered by a click from the ui
      $scope.add = function() {
	  // Same pattern as above minus comments and with the
	  // function defined anonymously and inline. Once you get
	  // your feet under you, this is the preferred method of
	  // passing callbacks. 

	  // Also note Angular binds $scope.say to the input textbox
	  // on the html page. When the user changes the value, this
	  // variable is automatically updated, so when the user
	  // clicks the add button, this value is already updated to
	  // the value the users wants inserted.
	  $helloService.add_said($scope.say, function(data) { $scope.last_id = data; $helloService.all_said(say_callback, say_callback_fail); }, function(data) { $scope.errors = "Failed to add"; });
      }


      // A function to delete by index
      $scope.delete = function(index) {
	  console.log("Calling delete");
	  var id = $scope.said[index]['id'];
	  $helloService.remove_said(id, function(data) { $helloService.all_said(say_callback, say_callback_fail); }, function(data) { $scope.errors = "Failed to delete."; });
      }

  }]);
