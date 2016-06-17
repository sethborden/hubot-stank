 # Description:
 #   When you say, 'hubot stank' -- hubot get's you some awesome music.
 #
 # Dependencies:
 #   None
 #
 # Configuration:
 #   GOOGLE_API_KEY = <google search api key>
 #
 # Commands:
 #   hubot stank
 #
 # Author:
 #   Seth Borden
 #
 
module.exports = (robot) ->
    unless process.env.GOOGLE_API_KEY
        robot.logger.error 'GOOGLE_API_KEY is not set.'
        return msg.send "You must configure the GOOGLE_API_KEY environment variable"
    awesomeBands = [
        "creed",
        "nickleback",
        "hoobastank",
        "limp bizkit",
        "daughtry",
        "3 Doors Down",
        "P.O.D."
        "puddle of mudd",
        "seether",
        "staind"
    ]
    robot.respond /stank/i, (msg) ->
        band = msg.random awesomeBands
        broism = msg.random [
            "OMFG #{band} is off the chain!",
            "Dope doesn't even begin to describe #{band}.",
            "Brah -- I just can't even...#{band}...brah...",
            "I can't even deal with the whiny kid junk...here's some #{band}"
        ]
        robot.http("https://www.googleapis.com/youtube/v3/search")
            .query({
                order: 'relevance'
                part: 'snippet'
                type: 'video'
                maxResults: 15
                q: "vevo #{band}"
                key: process.env.GOOGLE_API_KEY
            })
            .get() (err, res, body) -> 
                if err 
                    robot.logger.error err
                    return robot.emit 'error', err, msg
                try
                    if res.statusCode is 200
                        videos = JSON.parse(body)
                        robot.logger.debug "Videos, #{JSON.stringify(videos)}"
                    else 
                        return robot.emit 'error', "#{res.statusCode}: #{body}", msg
                catch error
                    robot.logger.error error
                    return msg.send "Error! #{body}"
                videos = videos.items
                video = msg.random videos
                msg.send "#{broism}\nhttp://www.youtube.com/watch?v=#{video.id.videoId}"
