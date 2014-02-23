#!/usr/bin/env ruby

# Author:  Andy Olsen (andy@59clouds.com)
# Date:    23 Feb 2014
# Purpose: A simple Grape Hello World API

require 'grape'
require 'm/builder'

module Hello
  class Rest < Grape::API
    format :json

    get '/say/all' do
      model = M::Builder.instance.get_model(M::Builder::HELLO)
      say = model.read_all()
      return say
    end

    post '/say/' do
      model = M::Builder.instance.get_model(M::Builder::HELLO)
      ids = model.create(params[:say])
      return ids
    end

    get '/say/:id' do
      model = M::Builder.instance.get_model(M::Builder::HELLO)
      id = params[:id].to_i
      say = model.read(id)
      return say
    end

    put '/say/:id' do
      model = M::Builder.instance.get_model(M::Builder::HELLO)
      id = params[:id].to_i
      say = params[:say]
      ids = model.update(id,say)
      return ids
    end

    delete '/say/:id' do
      model = M::Builder.instance.get_model(M::Builder::HELLO)
      id = params[:id].to_i
      ids = model.delete(id)
      return ids
    end

  end
end

