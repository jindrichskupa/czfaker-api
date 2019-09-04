require 'sinatra'
require 'json'
require 'cz_faker'


allowed_klasses = CzFaker.constants.select {|c| CzFaker.const_get(c).is_a? Class}

set :json_encoder, :to_json

class CzFakerAPI < Sinatra::Base

def par_from_params(param)
  if param == nil 
    "nil"
  elsif ["true", "false"].include?(param)
    param
  else
    ":#{param}"
  end
end

get '/:klass/:method' do
  keys = %i[ klass ]

  method = params[:method]

  klasses = [ 'CzFaker' ]
  
  keys.each do |k|
    klass = params[k].split("_").map(&:capitalize).join
    klasses << klass if allowed_klasses.include?(klass.to_sym)
  end

  klass = klasses.join("::")

  allowed_methods = ( Object.const_get(klass).methods - Object.methods )

  faker_call = [ klass, params[:method] ].join "." if allowed_methods.include?(params[:method].to_sym)

  eval faker_call

  parameters = Object.const_get(klass).method(method.to_sym).parameters
  
  call_params = []

  parameters.each do |par|
    call_params << par_from_params(params[par[1]])
  end

  faker_call = faker_call + "(" + call_params.join(',')  + ")"

  puts faker_call
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

get '/validator/:method' do
  keys = %i[ klass ]

  klasses = [ 'CzFaker::Validator' ]

  keys.each do |k|
    klass = params[k].split("_").map(&:capitalize).join
    klasses << klass if allowed_klasses.include?(klass.to_sym)
  end

  klass = klasses.join("::")

  faker_call = [ klass, params[:method] ].join "."

  eval faker_call
end
end
