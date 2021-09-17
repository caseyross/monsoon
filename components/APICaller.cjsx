React = require 'react'

Autosuggest = require 'react-autosuggest'
DataAttribution = require './DataAttribution.cjsx'
WeatherDisplay = require './WeatherDisplay.cjsx'

OWConfig = require '../config/OWConfig.js'
cities = require '../data/cities.js'

module.exports = React.createClass

    getInitialState: ->
        search_text: ''
        suggestions: []
        city: ''
        weather: null

    updateSearchText: (event, { newValue }) ->
        @setState
            search_text: newValue

    updateSuggestions: ( { value } ) ->
        @getSuggestionsFromAPI value
        .then (suggestions) =>
            @setState
                suggestions: suggestions

    getSuggestionsFromAPI: (query) ->
        i = 0
        suggestions = []
        while suggestions.length < 10 and i < cities.length
            current_city = cities[i]
            if current_city.n.toLowerCase().startsWith(query)
                suggestions.push(current_city)
            i += 1
        Promise.resolve suggestions

    chooseSuggestion: ( event, { suggestion } ) ->
        @getWeatherFromAPI [ suggestion.y, suggestion.x ]
        .then (weather) =>
            @setState
                city: suggestion.n
                weather: weather
                search_text: ''

    getWeatherFromAPI: ([ lat, lon ]) ->
        url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&units=metric&appid=#{OWConfig.API_KEY}"
        fetch url
        .then (res) ->
            switch res.status
                when 200
                    res.json()
                else
                    throw new Error('Weather API did not respond as expected')
        .then (json) ->
            json
        .catch (err) ->
            console.log err
            null
            
    renderWeatherOrAttribution: ->
        if @state.weather?
            <WeatherDisplay
                weather={ @state.weather }
                location={ @state.city }
            />
        else
            <DataAttribution />
    
    render: ->
        <div>
            <Autosuggest
                suggestions={ @state.suggestions }
                onSuggestionsUpdateRequested={ @updateSuggestions }
                getSuggestionValue={ (suggestion) -> suggestion.n + ', ' + suggestion.c }
                renderSuggestion={ (suggestion) ->
                    <span>
                        { suggestion.n + ', ' + suggestion.c }
                    </span>
                }
                inputProps={
                    value: @state.search_text
                    onChange: @updateSearchText
                    type: 'search'
                    placeholder: 'Where?'
                }
                onSuggestionSelected={ @chooseSuggestion }
            />
            { @renderWeatherOrAttribution() }
        </div>