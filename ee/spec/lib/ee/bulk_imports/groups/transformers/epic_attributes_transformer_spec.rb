# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EE::BulkImports::Groups::Transformers::EpicAttributesTransformer do
  let_it_be(:importer_user) { create(:user) }
  let_it_be(:group) { create(:group) }
  let_it_be(:bulk_import) { create(:bulk_import, user: importer_user) }
  let_it_be(:entity) { create(:bulk_import_entity, bulk_import: bulk_import, group: group) }
  let_it_be(:context) { ::BulkImports::Pipeline::Context.new(entity) }

  describe '#transform' do
    it 'transforms the epic attributes' do
      transformed = subject.transform(context, epic_data)

      expect(transformed).to eq({
        'title' => 'title',
        'description' => 'description',
        'state' => 'opened',
        'create_at' => '2021-01-27T03:42:30Z',
        'closed_at' => nil,
        'start_date' => nil,
        'start_date_fixed' => nil,
        'start_date_is_fixed' => false,
        'due_date_fixed' => nil,
        'due_date_is_fixed' => false,
        'relative_position' => 1073716855,
        'confidential' => false,
        'group_id' => group.id,
        'author_id' => importer_user.id,
        'parent' => nil,
        'children' => [],
        'labels' => []
      })
    end

    context 'labels' do
      it 'maps the existing labels' do
        label = create(:group_label, group: group)
        data = epic_data(labels_titles: [label.title, 'NON EXISTING TITLE'])

        transformed_data = subject.transform(context, data)

        expect(transformed_data['labels'].to_a).to contain_exactly(label)
      end
    end

    context 'parent and children epics' do
      it 'sets parent and child epics when they exist' do
        parent = create(:epic, group: group)
        child = create(:epic, group: group)
        data = epic_data(parent_iid: parent.iid, children_iids: [child.iid])

        transformed_data = subject.transform(context, data)

        expect(transformed_data['parent']).to eq(parent)
        expect(transformed_data['children']).to contain_exactly(child)
      end

      it 'removes the parent and children id when they dont exist' do
        data = epic_data(parent_iid: 9998, children_iids: [9999])

        transformed_data = subject.transform(context, data)

        expect(transformed_data['parent']).to be_nil
        expect(transformed_data['children']).to be_empty
      end
    end

    context 'epic author' do
      it 'finds user by primary confirmed email' do
        member_user = create(:user, email: 'member@email.com')
        group.add_owner(member_user)

        data = epic_data(public_email: member_user.email)

        transformed_data = subject.transform(context, data)

        expect(transformed_data['author_id']).to eq(member_user.id)
      end

      it 'falls back to the importer user if primary email is not confirmed' do
        member_user = create(:user, :unconfirmed, email: 'member@email.com')

        group.add_owner(member_user)

        data = epic_data(public_email: member_user.email)

        transformed_data = subject.transform(context, data)

        expect(transformed_data['author_id']).to eq(importer_user.id)
      end

      it 'findes user by secondary confirmed email' do
        secondary_email = 'other@email.com'
        member_user = create(:user, email: 'member@email.com')
        create(:email, :confirmed, user: member_user, email: secondary_email)
        group.add_owner(member_user)

        data = epic_data(public_email: secondary_email)

        transformed_data = subject.transform(context, data)

        expect(transformed_data['author_id']).to eq(member_user.id)
      end

      it 'falls back to the importer user if secondary email is not confirmed' do
        secondary_email = 'other@email.com'
        member_user = create(:user, email: 'member@email.com')
        create(:email, user: member_user, email: secondary_email)
        group.add_owner(member_user)

        data = epic_data(public_email: secondary_email)

        transformed_data = subject.transform(context, data)

        expect(transformed_data['author_id']).to eq(importer_user.id)
      end
    end

    def epic_data(parent_iid: nil, children_iids: [], labels_titles: [], public_email: '')
      {
        'title' => 'title',
        'description' => 'description',
        'state' => 'opened',
        'create_at' => '2021-01-27T03:42:30Z',
        'closed_at' => nil,
        'start_date' => nil,
        'start_date_fixed' => nil,
        'start_date_is_fixed' => false,
        'due_date_fixed' => nil,
        'due_date_is_fixed' => false,
        'relative_position' => 1073716855,
        'confidential' => false,
        'author' => {
          'public_email' => public_email
        },
        'parent' => {
          'iid' => parent_iid
        },
        'children' => {
          'nodes' => children_iids.map { |iid| { 'iid' => iid } }
        },
        'labels' => {
          'nodes' => labels_titles.map { |title| { 'title' => title } }
        }
      }
    end
  end
end
