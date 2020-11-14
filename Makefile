# This bucket name must be the same as the name for your website!
BUCKET_NAME="evankozliner.com"
STACK_NAME="PersonalWebsite"

# TODO 
# Install script that adds correct version of bundler, ruby, jekyll, tmux, aws cli, mediumexporter

all:
	make build
	make build-prod
	make create
	echo Sleeping so our bucket exists to upload to...
	sleep 10
	make deploy

create: 
	aws cloudformation create-stack \
	  --stack-name $(STACK_NAME) \
	  --template-body file://cloudformation/template.yaml \
	  --parameters ParameterKey=SiteBucketName,ParameterValue=$(BUCKET_NAME)

deploy: build-prod
	aws s3 cp _site/ s3://$(BUCKET_NAME) --recursive

empty-bucket:
	aws s3 rm s3://$(BUCKET_NAME) --recursive

destroy: empty-bucket
	aws cloudformation delete-stack --stack-name $(STACK_NAME)

build:
	bundle exec jekyll build

build-prod:
	JEKYLL_ENV=production jekyll build

serve: 
	bundle exec jekyll build
	bundle exec jekyll serve --livereload

# Usage make post=https://towardsdatascience.com/aws-iam-introduction-20c1f017c43 pull
#echo Creating file for $(post)
	#touch _texts/$(post).md
	#mediumexporter  $(post) --jekyll >> _texts/$(post).md
pull:
	ruby medium_converter.rb $(post)
