local SCRIPT_NAME = "mpv_thumbnail_script"

local default_cache_base = ON_WINDOWS and os.getenv("TEMP") or (os.getenv("XDG_CACHE_HOME") or "/tmp/")

local thumbnailer_options = {
    -- The thumbnail directory
    cache_directory = join_paths(default_cache_base, "mpv_thumbs_cache"),

    ------------------------
    -- Generation options --
    ------------------------

    -- Automatically generate the thumbnails on video load, without a keypress
    autogenerate = true,

    -- Only automatically thumbnail videos shorter than this (seconds)
    autogenerate_max_duration = 3600, -- 1 hour

    -- SHA1-sum filenames over this length
    -- It's nice to know what files the thumbnails are (hence directory names)
    -- but long URLs may approach filesystem limits.
    hash_filename_length = 128,

    -- Use mpv to generate thumbnail even if ffmpeg is found in PATH
    -- ffmpeg does not handle ordered chapters (MKVs which rely on other MKVs)!
    -- mpv is a bit slower, but has better support overall (eg. subtitles in the previews)
    prefer_mpv = true,

    -- Explicitly disable subtitles on the mpv sub-calls
    mpv_no_sub = false,
    -- Add a "--no-config" to the mpv sub-call arguments
    mpv_no_config = false,
    -- Add a "--profile=<mpv_profile>" to the mpv sub-call arguments
    -- Use "" to disable
    mpv_profile = "",
    -- Hardware decoding
    mpv_hwdec = "no",
    -- High precision seek
    mpv_hr_seek = "yes",
    -- Output debug logs to <thumbnail_path>.log, ala <cache_directory>/<video_filename>/000000.bgra.log
    -- The logs are removed after successful encodes, unless you set mpv_keep_logs below
    mpv_logs = true,
    -- Keep all mpv logs, even the succesfull ones
    mpv_keep_logs = false,

    -- Disable the built-in keybind ("T") to add your own
    disable_keybinds = false,

    ---------------------
    -- Display options --
    ---------------------

    -- Move the thumbnail up or down
    -- For example:
    --   topbar/bottombar: 24
    --   rest: 0
    vertical_offset = 24,

    -- Adjust background padding
    -- Examples:
    --   topbar:       0, 10, 10, 10
    --   bottombar:   10,  0, 10, 10
    --   slimbox/box: 10, 10, 10, 10
    pad_top   = 10,
    pad_bot   =  0,
    pad_left  = 10,
    pad_right = 10,

    -- If true, pad values are screen-pixels. If false, video-pixels.
    pad_in_screenspace = true,
    -- Calculate pad into the offset
    offset_by_pad = true,

    -- Background color in BBGGRR
    background_color = "000000",
    -- Alpha: 0 - fully opaque, 255 - transparent
    background_alpha = 80,

    -- Keep thumbnail on the screen near left or right side
    constrain_to_screen = true,

    -- Do not display the thumbnailing progress
    hide_progress = false,

    -----------------------
    -- Thumbnail options --
    -----------------------

    -- The maximum dimensions of the thumbnails (pixels)
    thumbnail_width = 200,
    thumbnail_height = 200,

    -- The thumbnail count target
    -- (This will result in a thumbnail every ~10 seconds for a 25 minute video)
    thumbnail_count = 150,

    -- The above target count will be adjusted by the minimum and
    -- maximum time difference between thumbnails.
    -- The thumbnail_count will be used to calculate a target separation,
    -- and min/max_delta will be used to constrict it.

    -- In other words, thumbnails will be:
    --   at least min_delta seconds apart (limiting the amount)
    --   at most max_delta seconds apart (raising the amount if needed)
    min_delta = 5,
    -- 120 seconds aka 2 minutes will add more thumbnails when the video is over 5 hours!
    max_delta = 90,


    -- Overrides for remote urls (you generally want less thumbnails!)
    -- Thumbnailing network paths will be done with mpv

    -- Allow thumbnailing network paths (naive check for "://")
    thumbnail_network = false,
    -- Same as autogenerate_max_duration but for remote videos
    remote_autogenerate_max_duration = 1200, -- 20 min
    -- Override thumbnail count, min/max delta
    remote_thumbnail_count = 60,
    remote_min_delta = 15,
    remote_max_delta = 120,

    -- Try to grab the raw stream and disable ytdl for the mpv subcalls
    -- Much faster than passing the url to ytdl again, but may cause problems with some sites
    remote_direct_stream = true,

    -- Enable storyboards (requires yt-dlp in PATH). Currently only supports YouTube and Twitch VoDs
    storyboard_enable = true,
    -- Max thumbnails for storyboards. It only skips processing some of the downloaded thumbnails and doesn't make it much faster
    storyboard_max_thumbnail_count = 800,
    -- Most storyboard thumbnails are 160x90. Enabling this allows upscaling them up to thumbnail_height
    storyboard_upscale = false,
}

read_options(thumbnailer_options, SCRIPT_NAME)
