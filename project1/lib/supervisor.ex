defmodule Project1.Supervisor do
    use Supervisor
  
    def start_link() do
      Supervisor.start_link(__MODULE__,:ok)
    end
  
    def init(:ok) do
        children = [worker(Project1.Worker,[])]
        supervise(children, strategy: :simple_one_for_one,type: :worker)
    end
    
    def start_child(args1,args2) do
        {:ok,pid}=start_link()
        {:ok,child}=Supervisor.start_child(pid,[])
        Project1.Worker.search(child,args1,args2)
    end
end