'use strict';

describe('Service: HelloService', function () {

  // load the service's module
  beforeEach(module('appApp'));

  // instantiate service
  var HelloService;
  beforeEach(inject(function (_HelloService_) {
    HelloService = _HelloService_;
  }));

  it('should do something', function () {
    expect(!!HelloService).toBe(true);
  });

});
