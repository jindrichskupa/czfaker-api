require 'sinatra'
require 'json'
require 'cz_faker'

class CzFakerAPI < Sinatra::Base

  set :json_encoder, :to_json

  def param_from_params(param)
    if param == nil 
      "nil"
    elsif ["true", "false"].include?(param)
      param
#    elsif ( Integer(param) rescue false )
#      Integer(param)
#    elsif ( Float(param) rescue false )
#      Float(param)      
    else
      "\"#{param}\""
    end
  end

  def params_to_klass(klasses ,params)
    keys = %i[ klass ]

    allowed_klasses = CzFaker.constants.select {|c| CzFaker.const_get(c).is_a? Class}

    klasses

    keys.each do |k|
      klass = params[k].split("_").map(&:capitalize).join
      klasses << klass if allowed_klasses.include?(klass.to_sym)
    end

    klasses.join("::")
  end

  def params_to_method_params(klass, method)
    parameters = Object.const_get(klass).method(method.to_sym).parameters
    
    call_params = []

    parameters.each do |par|
      call_params << param_from_params(params[par[1]])
    end

    call_params.join(',')
  end

  def klass_and_method_to_call(klass, method)
    allowed_methods = ( Object.const_get(klass).methods - Object.methods )
    [ klass, method ].join "." if allowed_methods.include?(method.to_sym)
  end

  get '/:klass/:method' do
    klasses = [ 'CzFaker' ]

    method = params[:method]
    klass = params_to_klass(klasses, params)
    faker_call = klass_and_method_to_call(klass, method)
    faker_call_params = params_to_method_params(klass, method)
    faker_call = faker_call + "(" + faker_call_params  + ")"

    begin
      result = eval(faker_call)
      {call: faker_call, result: result}.to_json
    rescue SyntaxError => se
      status 400
      {call: faker_call, message: 'Server problem or wrong call'}.to_json
    rescue
      status 500
      {call: faker_call, message: 'Server problem or wrong call'}.to_json
    end

  end

  get '/validator/:klass/:method' do
    klasses = [ 'CzFaker::Validator' ]

    method = params[:method] + "?"
    
    klass = params_to_klass(klasses, params)
    faker_call = klass_and_method_to_call(klass, method)
    faker_call_params = params_to_method_params(klass, method)
    faker_call = faker_call + "(" + faker_call_params  + ")"

    begin
      result = eval(faker_call)
      {call: faker_call, result: result}.to_json
    rescue SyntaxError => se
      status 400
      {call: faker_call, message: 'Server problem or wrong call'}.to_json
    rescue
      status 500
      {call: faker_call, message: 'Server problem or wrong call'}.to_json
    end

  end
end
