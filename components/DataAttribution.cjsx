React = require 'react'

FlexContainer = require './FlexContainer.cjsx'

module.exports = React.createClass

    style: ->
        color: 'gray'

    render: ->
        <FlexContainer direction='column' padding='20px 0'>
            <span style={ @style() }>
                Powered by:
            </span>
            <a href='https://openweathermap.org/current' style={ @style() }>
                OpenWeather (weather)
            </a>
            <a href='https://simplemaps.com/data/world-cities' style={ @style() }>
                simplemaps (places)
            </a>
        </FlexContainer>