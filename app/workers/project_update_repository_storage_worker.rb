# frozen_string_literal: true

class ProjectUpdateRepositoryStorageWorker # rubocop:disable Scalability/IdempotentWorker
  extend ::Gitlab::Utils::Override
  include UpdateRepositoryStorageWorker

  private

  override :find_repository_storage_move
  def find_repository_storage_move(repository_storage_move_id)
    ProjectRepositoryStorageMove.find(repository_storage_move_id)
  end

  override :find_container
  def find_container(container_id)
    Project.find(container_id)
  end

  override :update_repository_storage
  def update_repository_storage(repository_storage_move)
    ::Projects::UpdateRepositoryStorageService.new(repository_storage_move).execute
  end
end
