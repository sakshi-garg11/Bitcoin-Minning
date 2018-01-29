defmodule Project1 do
  def main(args \\ [1]) do
    {address,_}=:inet_parse.strict_address('#{args}');
    if address == :error do
      Project1.Dist.start_connection(:project1,address)
      {:ok,pid_manager}=Project1.Manager.start_link()
      
      cores = System.schedulers_online
    
      for _ <- 1..cores, do:
      spawn(Project1,:process_server,[args,pid_manager])
     
      halt(0,args,pid_manager)
    else
      Project1.Worker.connect(args);
    end
  end
 
  def process_server(args,pid_manager) do
    random="97504936"<>RandomBytes.base16
    if Project1.Manager.get(pid_manager,String.to_atom(random))== nil do
      Project1.Supervisor.start_child(random,List.first(args))
      Project1.Manager.put(pid_manager,String.to_atom(random),1)
    end
    process_server(args,pid_manager)
  end

  def halt(value,args,pid_manager) do
    registered=Node.list
    if length(registered) > value do
      random="97504936"<>RandomBytes.base16
      if Project1.Manager.get(pid_manager,String.to_atom(random))==nil do
        Node.spawn(List.last(Node.list),Project1.Supervisor,:start_child,[random,List.first(args)])
        Project1.Manager.put(pid_manager,String.to_atom(random),1)
        halt(length(registered),args,pid_manager)
      end
    end
    halt(length(registered),args,pid_manager)
  end

end