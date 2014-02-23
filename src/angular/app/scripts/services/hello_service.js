'use strict';

angular.module('appApp')
  .service('HelloService', ['$http', function HelloService($http) {
      return {
	  // This method takes two callback, one to execute on success and the other to execute on failur
	  all_said: function(cb, fail_cb) { 
	      $http.get('/hello/say/all').success(cb).error(fail_cb);
	  },

	  // This method declared all inline. Once you get used to the
	  // format, you begin to appreciate the lack of verbosity.
	  add_said: function(data, cb, fail_cb) { $http.post('/hello/say/', {"say": data}).success(cb).error(fail_cb); },

	  // This method declared all inline. Once you get used to the
	  // format, you begin to appreciate the lack of verbosity.
	  remove_said: function(id, cb, fail_cb) { $http.delete('/hello/say/' + id).success(cb).error(fail_cb); }
      }
  }]);
