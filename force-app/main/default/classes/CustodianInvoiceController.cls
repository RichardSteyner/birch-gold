public class CustodianInvoiceController {
    
    public String lastApprover {get; set;}
    
    public CustodianInvoiceController(ApexPages.StandardController stdController) {
        /*List<StepsAndWorkitems> steps = [SELECT CompletedDate, CreatedById, CreatedDate,Id,IsDeleted,LastActorId,
                                            LastModifiedById,LastModifiedDate,ProcessDefinitionId,Status,SubmittedById
                                            ,SystemModstamp,TargetObjectId, (SELECT ID, ProcessNodeId, StepStatus,
                                            Comments,TargetObjectId,ActorId,CreatedById,IsDeleted,IsPending,
                                            OriginalActorId,ProcessInstanceId,RemindersSent,CreatedDate 
                                            FROM StepsAndWorkitems where StepStatus='Approved' order by CreatedDate desc limit 1) FROM ProcessInstance
                                            where ProcessInstance.TargetObjectId = 'a1C0v000000Zbu3EAC' 
                                            order by CompletedDate desc limit 1];*/
        List<ProcessInstance> instances = [SELECT Id, (SELECT ID, ActorId
                                            			FROM StepsAndWorkitems 
                                                     	where StepStatus='Approved' 
                                                     	order by CreatedDate desc limit 1) 
                                             FROM ProcessInstance
                                             where ProcessInstance.TargetObjectId =: stdController.getId()
                                             order by CompletedDate desc limit 1];
        
        String auxID = null;
        for(ProcessInstance pi : instances){
            for(ProcessInstanceHistory step : pi.StepsAndWorkitems){
                auxID = step.ActorId;
            }
        }
        
        if(auxID!=null){
            System.debug('Find last approver id');
            for(User u : [select Id, Name from User where Id =: auxId]){
                lastApprover = u.Name;
            }
        }
    }

}