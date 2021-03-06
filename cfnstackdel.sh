#!/bin/bash
#hn=$1
hn=Provision15
 
aws cloudformation describe-stacks | grep StackName | awk -F":" '{print $2}' | tr -d '\"' | tr -d '\,' | grep "\b${hn}\b"
 
if [[ $? == "0" ]]
then
        aws cloudformation delete-stack --stack-name ${hn}
        CfnStackName=${hn}
        CfnStackRegion=us-west-2
        stackStatus="DELETE_IN_PROGRESS"
        while [[ 1 ]]; do
                echo aws cloudformation describe-stacks --region "${CfnStackRegion}" --stack-name "${CfnStackName}"
                aws cloudformation describe-stacks --region "${CfnStackRegion}" --stack-name "${CfnStackName}" >> /dev/null
                if [[ $? != 0 ]]
                then
                stackStatus="DELETE_COMPLETE"
                fi
                echo "    StackStatus: $stackStatus"
                #if [[ "$stackStatus" == "ROLLBACK_IN_PROGRESS" ]] || [[ "$stackStatus" == "ROLLBACK_COMPLETE" ]]; then
                #echo "Error occurred deleting AWS CloudFormation stack and returned status code ROLLBACK_IN_PROGRESS. Details:"
                #echo "$responseOrig"
                #exit -1
                if [[ "$stackStatus" == "DELETE_COMPLETE" ]]; then
                break
                fi
 
        # Sleep for 5 seconds, if stack deletion in progress
                sleep 5
        done
 
else
        echo "No Stack by the name ${hn}"
fi
