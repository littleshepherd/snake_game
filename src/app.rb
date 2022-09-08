require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"



class App
    def initialize
     @state = Model::initial_state
    end
    def start
        @view = View::Ruby2dView.new(self)
        
        timer_thread = Thread.new { init_timer(@view) }
        @view.start(@state)
        timer_thread.join

        
    end

    def init_timer(view)
        loop do
            if @state.game_finished 
                puts "Juego Finalizado"
                puts "Puntje: #{@state.snake.positions.length}"
                break
            end
            @state = Actions::move_snake(@state)
            view.renders(@state)
            sleep 0.5
        end
    end

    def send_action(action, params)
        # :change_direction, Model::Direction::UP
        # .send va a ajecutar un metodo que se llame como el simbolo que recibe
        new_state = Actions.send(action,@state, params)
        if new_state.hash != @state
            @state = new_state
            @view.renders(@state)
        end
    end

end
app = App.new
app.start