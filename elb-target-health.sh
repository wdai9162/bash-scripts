# TODO: $prefix for the TG arn -> add later
echo "Input Target Group ARN: "
read  tgARN

# retrieve TG members into var (output is singel string)
tgVar=$(aws elbv2 describe-target-health --target-group-arn $tgARN | jq -r '.TargetHealthDescriptions[].Target')
# store targets info into an array
readarray -t arr < <(echo $tgVar | jq -cs '.[]')

# iterate the array and return target health etc
# TODO: print one line per TG member, only return unhealthy targets (add conditional)
for i in "${arr[@]}";
    do
        read Id < <(echo $i | jq -r ".Id")
        read Port < <(echo $i | jq -r ".Port")
        aws elbv2 describe-target-health --targets Id=$Id,Port=$Port --target-group-arn $tgARN | jq -r '.TargetHealthDescriptions[] | .Target.Id, .Target.Port, .TargetHealth.State, .TargetHealth.Description'
done
