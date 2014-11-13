# this script appends an iteration number to each line of the partial mwu data generated by the generate R scripts
# for example, the results for gbest on ackley up to 2000 iterations will each have a gbest.2000 in the second column
# this is done so that results can be distinguished after stitching together

iterations=(500 1000 2000 5000 10000)
for i in "${iterations[@]}"; do sed -e "s/\$/.$i/g" *.$i.*; done

