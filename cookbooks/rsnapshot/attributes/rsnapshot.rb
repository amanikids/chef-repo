rsnapshot Mash.new unless attribute?(:rsnapshot)

rsnapshot[:directories] ||= []
rsnapshot[:scripts]     ||= {}
