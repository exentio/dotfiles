set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
set PANEL_FIFO /tmp/panel-fifo
source $fisher_home/config.fish

function fuck -d "Correct your previous console command"
  set -l exit_code $status
  set -l fucked_up_command $history[1]
  env TF_ALIAS=fuck PYTHONIOENCODING=utf-8    thefuck $fucked_up_command | read -l unfucked_command
  if [ "$unfucked_command" != "" ]
    eval $unfucked_command
    if test $exit_code -ne 0
      history --delete $fucked_up_command
      history --merge ^ /dev/null
      return 0
    end
  end
end

function convert-avchd --description "Convert AVCHD to MP4"
    ffmpeg -y -i "$argv[1]" -crf 20.0 -vcodec libx264 -filter:v scale=1280:720 -preset slow -c:a aac -ar 48000 -b:a 128k -coder 1 -flags +loop -cmp chroma -partitions +parti4x4+partp8x8+partb8x8 -me_method hex -subq 6 -me_range 16 -g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -b_strategy 1 -threads 4 "$argv[2]"
end
