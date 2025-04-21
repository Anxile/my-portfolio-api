class PostsController < ApplicationController
    require 'google/apis/drive_v3'
    require 'googleauth'
      
    begin
      scopes = [Google::Apis::DriveV3::AUTH_DRIVE]
      authorizer = Google::Auth.get_application_default(scopes)
      Rails.logger.info "Authorizer: #{authorizer.inspect}"
    
      @@drive = Google::Apis::DriveV3::DriveService.new
      @@drive.authorization = authorizer
      Rails.logger.info "Drive Service Initialized: #{@@drive.inspect}"
    rescue StandardError => e
      Rails.logger.error "Google Drive API initialization failed: #{e.message}"
      @@drive = nil
    end
  
    def index
      @post = Post.new
      @posts = Post.all
    
      if @@drive
        @posts.each do |post|
          if post.image_url.present?
            begin
              Rails.logger.info "Fetching metadata for Post ID: #{post.id}, Image URL: #{post.image_url}"
              file_metadata = @@drive.get_file(
                post.image_url,
                fields: 'id, name, mime_type, web_view_link, thumbnail_link'
              )
              post.instance_variable_set(:@file_metadata, file_metadata)
              Rails.logger.info "File Metadata: #{file_metadata.inspect}"
            rescue Google::Apis::ClientError => e
              Rails.logger.error "Failed to fetch file metadata for #{post.image_url}: #{e.message}"
            end
          end
        end
        render json: {
          posts: @posts,
          status: {code: 200, message: 'Posts retrieved successfully.'}
        }, status: :ok
      else
        Rails.logger.warn "Google Drive API is not initialized. Skipping file metadata retrieval."
        render json: {
          message: 'Google Drive API is not initialized.',
          status: {code: 500, message: 'Internal Server Error'}
        }, status: :internal_server_error
      end
    end
  
    def show
      @post = Post.find_by(id: params[:id])
      @comments = Comment.where(post_id: @post.id)

      if @@drive && @post.image_url.present?
        begin
          file_metadata = @@drive.get_file(
            @post.image_url,
            fields: 'id, name, mime_type, web_view_link, thumbnail_link'
          )
          @post.define_singleton_method(:file_metadata) { file_metadata }
          render json: {
            post: @post,
            image_url: file_metadata.web_view_link,
            comments: @comments,
            status: {code: 200, message: 'Post retrieved successfully.'}
          }, status: :ok
        rescue Google::Apis::ClientError => e
          Rails.logger.error "Failed to fetch file metadata for #{@post.image_url}: #{e.message}"
        end
      end
      
    end
  
    def create
      file_id = upload_image&.id
      @post = Post.new(
        title: params[:title],
        content: params[:content],
        user_id: current_user.id,
        image_url: file_id
      )
    
      if @post.save
        render json: {
          post: @post,
          status: {code: 201, message: 'Post created successfully.'}
        }, status: :created
      else
        render json: {
          status: {code: 422, message: 'Failed to create post.'},
          errors: @post.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  
    def upload_image
      file = params[:image]
      if file.present?
        metadata = Google::Apis::DriveV3::File.new(name: file.original_filename)
    
        uploaded_file = @@drive.create_file(
          metadata,
          fields: 'id',
          upload_source: file.tempfile.path,
          content_type: file.content_type
        )
    
        permission = Google::Apis::DriveV3::Permission.new(
          type: 'anyone',
          role: 'reader'
        )
        @@drive.create_permission(uploaded_file.id, permission)
    
        uploaded_file
      else
        Rails.logger.error "No file provided for upload"
        nil
      end
    end
  
  end
  