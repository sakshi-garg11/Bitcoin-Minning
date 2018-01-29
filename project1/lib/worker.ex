require Logger

defmodule Project1.Worker do
    use GenServer
  
    #client side

      def connect(args) do
      
        Project1.Dist.start_connection(:project1,:ok)
        value="project1@"<>List.first(args);
        ping=Node.ping :"#{value}"

        if ping == :pong do
         IO.puts("connection Successful")
         Process.sleep(1000)
         connect(args)
         else 
         IO.puts("Connection not established")
         Process.exit(self(),2);
        end
end
    
    def start_link() do
      GenServer.start_link(__MODULE__,:ok)
    end

    def search(server,input,counts) do
      GenServer.call(server,{:initialize,input,counts},:infinity)
    end

    def stop(server) do
      GenServer.stop(server)
    end
    
    
   #Server side

    def init(:ok) do
      {:ok,%{}}
    end

    def handle_call({:initialize, label,counts}, _from, _) do
        hashing(label,label,counts)
    end

    defp hashing(pointer,_label,counts) do
     label = "97504936" <> pointer
      pointer=:crypto.hash(:sha256,pointer)|>Base.encode16|>String.downcase;
      i = 0
      if(checking_str(pointer,label,counts,i)) do
       {:reply,pointer}
      end
      hashing(pointer,label,counts)
      {:noreply,[]} 
    end

    defp checking_str(value,label,pointer,counter) do
      if String.to_integer(pointer)==counter do
        #IO.puts "#{pointer}"
        IO.puts label<>"  "<>value
        {:reply,value}
      end
      if String.at("#{value}",counter)=="0" do
        counter=counter+1
        checking_str(value,label,pointer,counter)
      end
      {:noreply,[]}
    end 

end